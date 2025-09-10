import pkg from 'agora-access-token';
import dotenv from 'dotenv';
const { RtcTokenBuilder, RtcRole } = pkg;

// Load environment variables
dotenv.config();

// Get Agora credentials from .env
const APP_ID = process.env.AGORA_APP_ID?.replace(/["']/g, ''); // Remove any quotes
const APP_CERTIFICATE = process.env.AGORA_APP_CERTIFICATE?.replace(/["']/g, '');

console.log('🔍 Testing Agora Configuration');
console.log('----------------------------');
console.log('App ID:', APP_ID);
console.log('App Certificate:', APP_CERTIFICATE ? '*** (hidden for security)' : 'Not found');

if (!APP_ID || !APP_CERTIFICATE) {
  console.error('❌ Error: AGORA_APP_ID or AGORA_APP_CERTIFICATE is missing in .env');
  process.exit(1);
}

try {
  // Generate a test token
  const channelName = 'test_channel';
  const uid = 0;
  const role = RtcRole.PUBLISHER;
  const expirationTimeInSeconds = 3600;
  
  const token = RtcTokenBuilder.buildTokenWithUid(
    APP_ID,
    APP_CERTIFICATE,
    channelName,
    uid,
    role,
    expirationTimeInSeconds
  );

  console.log('\n✅ Agora Token Generated Successfully!');
  console.log('--------------------------------');
  console.log('Channel:', channelName);
  console.log('Token (first 30 chars):', token.substring(0, 30) + '...');
  console.log('UID:', uid);
  console.log('Expires in:', expirationTimeInSeconds, 'seconds');
  
  console.log('\n🎉 Your Agora setup is working correctly!');
  console.log('\nNext steps:');
  console.log('1. Start your server: `node src/app.js`');
  console.log('2. Test the video call endpoints');
  
} catch (error) {
  console.error('\n❌ Error generating Agora token:');
  console.error(error.message);
  console.error('\nPlease verify your Agora App ID and Certificate are correct.');
  process.exit(1);
}
