import { metaquizz } from "../../declarations/metaquizz";

document.getElementById("clickMeBtn").addEventListener("click", async () => {
  const name = document.getElementById("name").value.toString();
  // Interact with metaquizz actor, calling the greet method
  const greeting = await metaquizz.greet(name);

  document.getElementById("greeting").innerText = greeting;
});
