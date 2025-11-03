const express = require("express");
const mongoose = require("mongoose");

const app = express();
app.use(express.json());

const mongoUri = process.env.MONGO_URI || "mongodb://localhost:27017/testdb";

mongoose.connect(mongoUri, { useNewUrlParser: true, useUnifiedTopology: true })
  .then(() => console.log("✅ Connected to MongoDB"))
  .catch(err => console.error("❌ MongoDB connection error:", err));

const UserSchema = new mongoose.Schema({
  name: String,
  email: String
});

const User = mongoose.model("User", UserSchema);

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

const port = process.env.PORT || 3000;
app.listen(port, () => {
  console.log(`🌍 Server running on port ${port}`);
});
