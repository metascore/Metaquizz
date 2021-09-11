import { createRouter, createWebHashHistory } from "vue-router";

import Plug from "../Plug.vue";
import Stoic from "../Stoic.vue";
import HomePage from "../HomePage.vue";
import Quizz from "../Quizz.vue";

const routes = [
  { path: "/", component: HomePage },
  { path: "/plug", component: Plug },
  { path: "/quizz", component: Quizz },
  { path: "/stoic", component: Stoic },
];

const router = createRouter({
  history: createWebHashHistory(),
  routes,
});

export default router;
