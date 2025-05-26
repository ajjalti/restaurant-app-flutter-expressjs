const mongoose = require('mongoose');

const connectDB = async () => {
    try {
        await mongoose.connect(process.env.MONGO_URI);
        console.log('MongoDB connecté');
    } catch (err) {
        console.error('Erreur de connexion MongoDB', err);
        process.exit(1);
    }
};

module.exports = connectDB;



// const mongoose = require('mongoose');
// const uri = "mongodb+srv://super_admin:8vwVZmsbzlVYW3mp@cluster0.fofunfp.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0";
// const clientOptions = { serverApi: { version: '1', strict: true, deprecationErrors: true } };
// async function run() {
//   try {
//     // Create a Mongoose client with a MongoClientOptions object to set the Stable API version
//     await mongoose.connect(uri, clientOptions);
//     await mongoose.connection.db.admin().command({ ping: 1 });
//     console.log("Pinged your deployment. You successfully connected to MongoDB!");
//   } finally {
//     // Ensures that the client will close when you finish/error
//     await mongoose.disconnect();
//   }
// }
// run().catch(console.dir);
