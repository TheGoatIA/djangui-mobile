const mongoose = require('d:/Projets/NodeJS/djangui-api/node_modules/mongoose');

async function fixUser() {
  const uri = process.env.MONGODB_URI || 'mongodb://localhost:27017/kauri';
  try {
    await mongoose.connect(uri);
    const db = mongoose.connection.db;
    const res = await db.collection('users').updateOne(
      { email: 'tchoukouahaboris@gmail.com' },
      {
        $set: {
          'subscription.plan': 'business',
          'subscription.status': 'active',
          'subscription.startDate': new Date(),
          'subscription.endDate': new Date(Date.now() + 30 * 24 * 60 * 60 * 1000)
        }
      }
    );
    console.log('Successfully upgraded user account to Business in DB:', res.modifiedCount);
    await mongoose.disconnect();
  } catch (e) {
    console.log('Error:', e.message);
  }
}
fixUser();
