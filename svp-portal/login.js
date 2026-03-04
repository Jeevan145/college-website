function login() {
  const role = document.getElementById("role").value;
  const user = document.getElementById("username").value;
  const pass = document.getElementById("password").value;

  if (role === "student" && user === "student" && pass === "1234") {
    window.location.href = "student.html";
  }
  else if (role === "admin" && user === "admin" && pass === "admin123") {
    window.location.href = "admin.html";
  }
  else {
    alert("Invalid Credentials");
  }
}
