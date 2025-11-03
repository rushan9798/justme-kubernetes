const express = require("express");
const mongoose = require("mongoose");

const app = express();
app.use(express.json());

// MongoDB connection string from environment variable
const mongoUri = process.env.MONGO_URI || "mongodb://127.0.0.1:27017/testdb";

mongoose.connect(mongoUri, { useNewUrlParser: true, useUnifiedTopology: true })
  .then(() => console.log("✅ Connected to MongoDB"))
  .catch(err => console.error("❌ MongoDB connection error:", err));

// Define a simple schema
const UserSchema = new mongoose.Schema({
  name: String,
  email: String
});

const User = mongoose.model("User", UserSchema);

// Routes
app.get("/", (req, res) => {
  res.send("Node.js + MongoDB app is running 🚀");
});

app.post("/users", async (req, res) => {
  try {
    const user = new User(req.body);
    await user.save();
    res.status(201).send(user);
  } catch (err) {
    res.status(400).send(err);
  }
});

app.get("/users", async (req, res) => {
  const users = await User.find();
  res.send(users);
});

// Start server
const port = process.env.PORT || 3000;
app.listen(port, () => {
  console.log(`🌍 Server running on port ${port}`);
});

