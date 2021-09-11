<template>
  <div
    class="flex flex-col justify-center items-center bg-indigo-100 min-h-screen"
  >
    <div
      class="
        bg-white
        p-12
        rounded
        shadow-2xl
        flex flex-col
        justify-center
        my-10
        mx-10
      "
    >
      <h2 class="text-4xl font-bold text-gray-700 mb-8 text-center">
        Choose your username.
      </h2>
      <input
        type="text"
        id="name"
        class="
          border-4 border-gray-400
          rounded-2xl
          p-2
          outline-none
          focus:border-purple-400
          text-xl text-gray-600
          font-bold
          w-2/3
          mx-auto
        "
        v-model="username"
        maxlength="20"
      />
      <button
        class="
          rounded-2xl
          bg-blue-200
          font-bold
          text-gray-800
          px-10
          py-3
          block
          mx-auto
          text-2xl
          mt-8
        "
        id="welcome"
        @click="register()"
      >
        Ok
      </button>
    </div>
  </div>
</template>

<script>
import { ref } from "vue";
import { idlFactory } from "../../declarations/metaquizz/metaquizz.did.js";
import { Actor } from "@dfinity/agent";
import { canisterId } from "../../declarations/metaquizz/index.js";
import { useRouter } from "vue-router";

export default {
  setup() {
    const router = useRouter();
    const username = ref("");
    const isRegistering = ref(false);
    // const verifyConnectionAndAgent = async () => {
    //   const connected = await window.ic.plug.isConnected();
    //   if (!connected) await window.ic.plug.requestConnect({ whitelist, host });
    //   if (connected && !window.ic.plug.agent) {
    //     await window.ic.plug.createAgent({ whitelist, host });
    //   }
    // };

    const register = async () => {
      isRegistering.value = true;
      // verifyConnectionAndAgent();

      const myGameActor = Actor.createActor(idlFactory, {
        canisterId: canisterId,
        agent: window.ic.plug.agent,
      });

      console.log(myGameActor);

      // Get the user principal id
      const id = await window.ic.plug.agent.getPrincipal();

      //For dev : not to call in production
      if (process.env.NODE_ENV == "development") {
        window.ic.plug.agent.fetchRootKey();
      }

      let ourPlayer = { plug: id };
      let registration = {
        player: ourPlayer,
        name: username.value,
      };

      console.log(registration);

      myGameActor.addPlayer(registration).then((value) => console.log(value));

      router.push("/quizz");
    };
    return { username, register };
  },
};
</script>
