import pkg from 'agora-access-token';
const { RtcTokenBuilder, RtcRole } = pkg;

const APP_ID = process.env.AGORA_APP_ID;
const APP_CERTIFICATE = process.env.AGORA_APP_CERTIFICATE;
const TOKEN_EXPIRATION_TIME = 3600; // 1 hour

if (!APP_ID || !APP_CERTIFICATE) {
  throw new Error('Agora App ID and Certificate must be set in environment variables');
}

export const generateRtcToken = (channelName, uid) => {
  // Generate a token with the specified UID (0 for web, random for mobile)
  const role = RtcRole.PUBLISHER;
  const expirationTimeInSeconds = Math.floor(Date.now() / 1000) + TOKEN_EXPIRATION_TIME;
  
  // Build token with UID
  const token = RtcTokenBuilder.buildTokenWithUid(
    APP_ID,
    APP_CERTIFICATE,
    channelName,
    uid || 0,
    role,
    expirationTimeInSeconds
  );

  return {
    token,
    appId: APP_ID,
    channel: channelName,
    uid: uid || 0,
    role
  };
};

export const generateChannelName = (doctorId, patientId) => {
  // Create a unique channel name for the doctor-patient pair
  const ids = [doctorId, patientId].sort();
  return `call_${ids[0]}_${ids[1]}`;
};
