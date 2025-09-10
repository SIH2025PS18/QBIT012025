import React, { useEffect, useRef, useState } from "react";
import SimplePeer from "simple-peer";
import { socket } from "../lib/socket.js";
import { Button, message, Spin, Alert } from "antd";
import { useAuth } from "../context/AuthContext.jsx";

export default function VideoCall({ patient, doctorId }) {
  const { user } = useAuth(); // ✅ know if current user is doctor or patient
  const localVideoRef = useRef(null);
  const remoteVideoRef = useRef(null);
  const peerRef = useRef(null);
  const [started, setStarted] = useState(false);
  const [muted, setMuted] = useState(false);
  const [loading, setLoading] = useState(false);
  const [callStatus, setCallStatus] = useState("idle"); // idle, calling, in-call, ended
  const [consultationId, setConsultationId] = useState(null);
  const [error, setError] = useState(null);

  // ---- handle incoming WebRTC signal
  function handleSignal({ signal, from }) {
    console.log("Received signal from:", from);
    if (!peerRef.current) {
      // If we're not the initiator, create peer connection
      if (user.role === "patient") {
        startCall(false); // Patient responds to doctor's call
      }
      return;
    }
    try {
      peerRef.current.signal(signal);
    } catch (error) {
      console.error("Error handling signal:", error);
      message.error("Connection error occurred");
      setError("Connection error occurred");
    }
  }

  // ---- handle incoming call
  function handleIncomingCall(data) {
    console.log("Incoming call:", data);
    try {
      setCallStatus("calling");
      message.info(`Incoming call from Dr. ${data.fromName}`);
      
      // Auto-accept for demo purposes - in real app, show accept/reject UI
      setTimeout(() => {
        acceptCall(data);
      }, 1000);
    } catch (error) {
      console.error("Error handling incoming call:", error);
      message.error("Error handling incoming call");
      setError("Error handling incoming call");
    }
  }

  // ---- handle call accepted
  function handleCallAccepted(data) {
    console.log("Call accepted:", data);
    try {
      setCallStatus("in-call");
      message.success("Call connected");
      
      // If we're the caller, start the call
      if (data.from === user.id && !started) {
        startCall(true);
      }
    } catch (error) {
      console.error("Error handling call accepted:", error);
      message.error("Error establishing connection");
      setError("Error establishing connection");
    }
  }

  // ---- handle call rejected
  function handleCallRejected(data) {
    console.log("Call rejected:", data);
    try {
      setCallStatus("idle");
      message.error("Call rejected");
      setError("Call rejected by the other party");
    } catch (error) {
      console.error("Error handling call rejection:", error);
      setError("Error handling call rejection");
    }
  }

  // ---- handle call end
  function handleCallEnd(data) {
    console.log("Call ended:", data);
    try {
      setCallStatus("ended");
      cleanup();
      message.info("Call ended");
    } catch (error) {
      console.error("Error handling call end:", error);
      setError("Error ending call");
    }
  }

  // ---- handle socket errors
  function handleSocketError(errorData) {
    console.error("Socket error:", errorData);
    message.error(errorData.message || "Connection error occurred");
    setError(errorData.message || "Connection error occurred");
  }

  // ---- socket listener setup
  useEffect(() => {
    if (!patient?.id && user.role !== "patient") return;

    try {
      // Set up consultation ID
      const newConsultationId = `consultation_${doctorId}_${patient?.id || user.id}_${Date.now()}`;
      setConsultationId(newConsultationId);

      // Register user with socket server
      socket.emit("register", {
        userId: user.id,
        role: user.role,
        name: user.name
      });

      // Join consultation room
      socket.emit("join_consultation", {
        consultationId: newConsultationId,
        userId: user.id,
        role: user.role
      });

      // Set up socket listeners
      socket.on("webrtc-signal", handleSignal);
      socket.on("incoming_call", handleIncomingCall);
      socket.on("call_accepted", handleCallAccepted);
      socket.on("call_rejected", handleCallRejected);
      socket.on("webrtc-end", handleCallEnd);
      socket.on("error", handleSocketError);

      return () => {
        socket.off("webrtc-signal", handleSignal);
        socket.off("incoming_call", handleIncomingCall);
        socket.off("call_accepted", handleCallAccepted);
        socket.off("call_rejected", handleCallRejected);
        socket.off("webrtc-end", handleCallEnd);
        socket.off("error", handleSocketError);
        endCall();
      };
    } catch (error) {
      console.error("Error setting up socket listeners:", error);
      message.error("Failed to set up connection");
      setError("Failed to set up connection");
    }
  }, [patient, doctorId, user]);

  // ---- initiate call
  async function initiateCall() {
    if (!patient?.id) {
      message.error("No patient selected");
      setError("No patient selected");
      return;
    }

    setLoading(true);
    setCallStatus("calling");
    setError(null);
    
    try {
      // Request Agora token from backend
      const response = await fetch("http://localhost:5000/api/call/generate-token", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          doctorId: doctorId,
          patientId: patient.id,
          role: user.role
        })
      });

      const tokenData = await response.json();
      console.log("Token data:", tokenData);

      if (!response.ok) {
        throw new Error(tokenData.error || "Failed to get token");
      }

      // Notify patient about incoming call via socket
      socket.emit("initiate_call", {
        from: user.id,
        fromName: user.name,
        to: patient.id,
        doctorId: doctorId,
        patientId: patient.id,
        tokenData: tokenData
      });

      message.info("Calling patient...");
    } catch (err) {
      console.error("Failed to initiate call:", err);
      message.error(`Failed to initiate call: ${err.message}`);
      setCallStatus("idle");
      setError(`Failed to initiate call: ${err.message}`);
    } finally {
      setLoading(false);
    }
  }

  // ---- accept call
  async function acceptCall(callData) {
    try {
      // Request Agora token from backend
      const response = await fetch("http://localhost:5000/api/call/generate-token", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          doctorId: callData.doctorId,
          patientId: callData.patientId,
          role: user.role
        })
      });

      const tokenData = await response.json();
      console.log("Token data for accept:", tokenData);

      if (!response.ok) {
        throw new Error(tokenData.error || "Failed to get token");
      }

      // Accept the call
      socket.emit("accept_call", {
        from: user.id,
        to: callData.from,
        doctorId: callData.doctorId,
        patientId: callData.patientId,
        tokenData: tokenData
      });

      setCallStatus("in-call");
    } catch (err) {
      console.error("Failed to accept call:", err);
      message.error(`Failed to accept call: ${err.message}`);
      setCallStatus("idle");
      setError(`Failed to accept call: ${err.message}`);
    }
  }

  // ---- start call
  async function startCall(isInitiator = true) {
    try {
      const stream = await navigator.mediaDevices.getUserMedia({
        video: true,
        audio: true,
      });

      if (localVideoRef.current) {
        localVideoRef.current.srcObject = stream;
      }

      // Create peer connection
      const peer = new SimplePeer({
        initiator: isInitiator,
        trickle: false,
        stream,
        config: {
          iceServers: [
            { urls: "stun:stun.l.google.com:19302" },
            { urls: "stun:stun1.l.google.com:19302" }
          ],
        },
      });

      peerRef.current = peer;
      setStarted(true);

      // Send signals to the other side
      peer.on("signal", (signal) => {
        try {
          const targetId = user.role === "doctor" ? patient.id : doctorId;
          console.log("Sending signal to:", targetId);
          socket.emit("webrtc-signal", { 
            to: targetId, 
            from: user.id, 
            signal,
            consultationId
          });
        } catch (error) {
          console.error("Error sending signal:", error);
          message.error("Connection error");
          setError("Connection error");
        }
      });

      // Play remote stream
      peer.on("stream", (remoteStream) => {
        console.log("Received remote stream");
        if (remoteVideoRef.current) {
          remoteVideoRef.current.srcObject = remoteStream;
        }
      });

      peer.on("error", (err) => {
        console.error("Peer error:", err);
        message.error(`Connection error: ${err.message}`);
        setError(`Connection error: ${err.message}`);
      });

      peer.on("close", () => {
        console.log("Peer connection closed");
        cleanup();
      });

      peer.on("connect", () => {
        console.log("Peer connected");
        setCallStatus("in-call");
        message.success("Connected to patient");
      });
    } catch (err) {
      console.error("Failed to start call:", err);
      message.error(`Failed to access camera/microphone: ${err.message}`);
      setCallStatus("idle");
      setError(`Failed to access camera/microphone: ${err.message}`);
    }
  }

  // ---- end call
  function endCall() {
    try {
      if (peerRef.current) {
        peerRef.current.destroy();
        peerRef.current = null;
      }
      cleanup();
      
      // Notify other party
      const targetId = user.role === "doctor" ? patient?.id : doctorId;
      if (targetId) {
        socket.emit("webrtc-end", { 
          to: targetId, 
          from: user.id,
          consultationId
        });
      }
      
      // Notify backend to end call
      if (doctorId && patient?.id) {
        fetch("http://localhost:5000/api/call/end-call", {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
          },
          body: JSON.stringify({
            doctorId: doctorId,
            patientId: patient.id
          })
        }).catch(err => {
          console.error("Failed to notify backend:", err);
          message.error("Failed to properly end call");
          setError("Failed to properly end call");
        });
      }
      
      setCallStatus("ended");
      message.info("Call ended");
    } catch (error) {
      console.error("Error ending call:", error);
      message.error("Error ending call");
      setError("Error ending call");
    }
  }

  // ---- cleanup
  function cleanup() {
    try {
      setStarted(false);
      if (localVideoRef.current?.srcObject) {
        localVideoRef.current.srcObject.getTracks().forEach((t) => t.stop());
        localVideoRef.current.srcObject = null;
      }
      if (remoteVideoRef.current?.srcObject) {
        remoteVideoRef.current.srcObject.getTracks().forEach((t) => t.stop());
        remoteVideoRef.current.srcObject = null;
      }
    } catch (error) {
      console.error("Error during cleanup:", error);
      setError("Error during cleanup");
    }
  }

  // ---- mute toggle
  function toggleMute() {
    try {
      const tracks = localVideoRef.current?.srcObject?.getAudioTracks();
      if (tracks && tracks.length > 0) {
        tracks[0].enabled = !tracks[0].enabled;
        setMuted(!tracks[0].enabled);
      }
    } catch (error) {
      console.error("Error toggling mute:", error);
      message.error("Failed to toggle mute");
      setError("Failed to toggle mute");
    }
  }

  // ---- switch camera
  function switchCamera() {
    try {
      const videoTracks = localVideoRef.current?.srcObject?.getVideoTracks();
      if (videoTracks && videoTracks.length > 0) {
        // In a real implementation, you would cycle through available cameras
        message.info("Camera switched");
      }
    } catch (error) {
      console.error("Error switching camera:", error);
      message.error("Failed to switch camera");
      setError("Failed to switch camera");
    }
  }

  return (
    <div className="card">
      <h3>Video Consultation: {patient?.name || "No patient selected"}</h3>

      {error && (
        <Alert 
          message={error} 
          type="error" 
          showIcon 
          style={{ marginBottom: 16 }} 
          closable
          onClose={() => setError(null)}
        />
      )}

      {(patient?.id || user.role === "patient") ? (
        <>
          <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: 12 }}>
            <div>
              <h4>{user.role === "doctor" ? "Doctor" : "Patient"}</h4>
              <video
                ref={localVideoRef}
                autoPlay
                muted
                playsInline
                style={{ width: "100%", height: 200, background: "black", borderRadius: 8 }}
              />
            </div>
            <div>
              <h4>{user.role === "doctor" ? "Patient" : "Doctor"}</h4>
              <video
                ref={remoteVideoRef}
                autoPlay
                playsInline
                style={{ width: "100%", height: 200, background: "black", borderRadius: 8 }}
              />
            </div>
          </div>

          {/* Call status indicator */}
          <div style={{ margin: "12px 0", textAlign: "center" }}>
            <span 
              style={{ 
                padding: "4px 8px", 
                borderRadius: 4, 
                backgroundColor: 
                  callStatus === "idle" ? "#f0f0f0" :
                  callStatus === "calling" ? "#fff3cd" :
                  callStatus === "in-call" ? "#d4edda" : "#f8d7da",
                color: 
                  callStatus === "idle" ? "#666" :
                  callStatus === "calling" ? "#856404" :
                  callStatus === "in-call" ? "#155724" : "#721c24"
              }}
            >
              {callStatus === "idle" && "Ready to call"}
              {callStatus === "calling" && "Calling..."}
              {callStatus === "in-call" && "In call"}
              {callStatus === "ended" && "Call ended"}
            </span>
          </div>

          <div style={{ marginTop: 12, textAlign: "center" }}>
            {!started && callStatus === "idle" ? (
              <Button 
                type="primary" 
                onClick={initiateCall}
                loading={loading}
                disabled={!patient?.id}
              >
                Start Call
              </Button>
            ) : (
              <Button 
                danger 
                onClick={endCall}
                disabled={callStatus === "ended"}
              >
                End Call
              </Button>
            )}
            <Button 
              style={{ marginLeft: 8 }} 
              onClick={toggleMute}
              disabled={!started}
            >
              {muted ? "Unmute" : "Mute"}
            </Button>
            <Button 
              style={{ marginLeft: 8 }} 
              onClick={switchCamera}
              disabled={!started}
            >
              Switch Camera
            </Button>
          </div>
        </>
      ) : (
        <p style={{ color: "#888", textAlign: "center" }}>Select a patient from the queue to start a call.</p>
      )}
    </div>
  );
}