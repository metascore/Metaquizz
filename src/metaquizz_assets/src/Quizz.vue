<template>
  <div v-if="isLoading">
    <loader />
  </div>
  <div v-else>
    <h1 id="Title">{{ quizz.title }}</h1>
    <div class="container-global">
      <form class="quizz-form">
        <li v-for="(question, index) in questions" :key="index">
          <div class="question-block">
            <h4>{{ question.question }}</h4>
            <div>
              <input type="radio" :name="index" value="0" checked />
              <label>
                {{ quizz.questions[index].answers[0].text }}
              </label>
            </div>
            <div>
              <input type="radio" :name="index" value="1" />
              <label>
                {{ quizz.questions[index].answers[1].text }}
              </label>
            </div>
            <div>
              <input type="radio" :name="index" value="2" />
              <label>
                {{ quizz.questions[index].answers[2].text }}
              </label>
            </div>
          </div>
        </li>

        <button @click.prevent="getResult()">Submit your answers !</button>
      </form>

      <div class="resultats">
        <h2>Motoko School © 2021</h2>
        <p class="help"></p>
        <p class="note"></p>
      </div>
    </div>
  </div>
</template>
<script>
import { defineComponent, ref } from "vue";
import { idlFactory } from "../../declarations/metaquizz/metaquizz.did.js";
import { Actor } from "@dfinity/agent";
import { canisterId } from "../../declarations/metaquizz/index.js";

import Loader from "./UI/Loader.vue";

export default defineComponent({
  setup() {
    const isLoading = ref(true);
    const quizz = ref(null);
    const questions = ref(null); //Used for v-for
    const studentAnswers = ref([]);

    const myGameActor = Actor.createActor(idlFactory, {
      canisterId: canisterId,
      agent: window.ic.plug.agent,
    });

    const getData = async () => {
      let h = await myGameActor.sendAQuizz(BigInt(1));
      quizz.value = h[0];
      questions.value = h[0].questions;
      isLoading.value = false;
      return;
    };

    getData();

    const getResult = async () => {
      studentAnswers.value = [];
      for (let i = 0; i < questions.value.length; i++) {
        studentAnswers.value.push(
          //@ts-ignore
          document.querySelector(`input[name="${i}"]:checked`).value
        );
      }
      let tableauToSend = studentAnswers.value.map((x) => BigInt(x));

      let id = await window.ic.plug.agent.getPrincipal();
      let ourPlayer = { plug: id };

      let score = await myGameActor.checkResultQuizz(
        ourPlayer,
        tableauToSend,
        quizz.value.quizzID
      );
      console.log(score);
    };
    return {
      getData,
      quizz,
      questions,
      getResult,
      isLoading,
    };
  },
  components: {
    Loader,
  },
});
</script>

<style scoped>
*,
::before,
::after {
  box-sizing: border-box;
  margin: 0;
  padding: 0;
}
body {
  font-family: Arial, Helvetica, sans-serif;
}
h1 {
  font-weight: lighter;
  text-align: center;
  letter-spacing: 2px;
  padding: 30px 0;
  font-size: 40px;
}
.container-global {
  width: 70%;
  height: auto;
  max-width: 800px;
  margin: 0 auto;
  /* background-color: brown; */
}
.question-block {
  padding: 15px 25px 25px;
  margin: 20px;
  border-radius: 5px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.5);
}
.question-block h4 {
  padding: 7px 0px;
  font-size: 18px;
}
.question-block input[type="radio"] {
  transform: scale(1.7);
  margin: 10px;
}
.resultats {
  padding: 25px;
  margin: 10px 0px 70px;
  border-radius: 5px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.5);
}
.resultats h2 {
  text-align: center;
}
.help {
  text-align: center;
  font-size: 20px;
  margin-top: 10px;
}
.note {
  text-align: center;
  font-size: 25px;
  margin-top: 10px;
}
form button {
  border: none;
  outline: none;
  border: 1px solid #333;
  border-radius: 5px;
  display: block;
  margin: 25px auto;
  padding: 15px 25px;
  cursor: pointer;
  font-size: 25px;
  transition: background-color 0.2 ease-in-out;
}
form button:hover {
  background-color: lightblue;
}
.echec {
  animation: echec 0.3s ease-in-out;
}
.test {
  background-color: pink;
}
@keyframes echec {
  0% {
    transform: translateX(0px);
  }
  33% {
    transform: translateX(5px);
  }
  66% {
    transform: translateX(-5px);
  }
  10% {
    transform: translateX(0px);
  }
}
li {
  list-style: none;
}
</style>
