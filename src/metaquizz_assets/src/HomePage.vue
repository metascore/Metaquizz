<template>
  <div class="flex flex-col justify-center bg-indigo-100 min-h-screen">
    <h1 class="text-5xl text-gray-700 text-center font-bold mt-10">
      A simple example to connect with Metascore 🌀
    </h1>
    <div class="flex flex-row justify-around align-items mt-14">
      <button
        class="
          rounded-2xl
          bg-blue-200
          font-bold
          text-gray-800
          px-6
          py-3
          block
          mx-auto
          text-2xl
        "
        @click="usePlug()"
      >
        Connect with Plug
      </button>
      <button
        class="
          rounded-2xl
          bg-blue-200
          font-bold
          text-gray-800
          px-6
          py-3
          block
          mx-auto
          text-2xl
        "
        @click="useStoic()"
      >
        Connect with Stoic
      </button>
    </div>
    <div></div>
  </div>
</template>

<script>
import { useRouter } from "vue-router";
import { canisterId } from "../../declarations/metaquizz/index.js";
import { StoicIdentity } from "ic-stoic-identity";

export default {
  setup() {
    const router = useRouter();
    const useStoic = () => {
      StoicIdentity.load().then(async (identity) => {
        if (identity !== false) {
          //ID is a already connected wallet!
        } else {
          //No existing connection, lets make one!
          identity = await StoicIdentity.connect();

          //To store the identity temporary
          window.ic.identityStoic = identity;
        }

        //Lets display the connected principal!
        console.log(identity.getPrincipal().toText());
        router.push("/stoic");
      });
    };

    const usePlug = async () => {
      //Test if the user has Plug extension installed (other way?)
      if (typeof window.ic == "undefined") {
        console.log("No plug extension");
        return;
      }
      //Your game canister
      const myGameCanister = canisterId;

      // Whitelist
      const whitelist = [myGameCanister];

      // Host
      const host =
        process.env.NODE_ENV == "development"
          ? "http://127.0.0.1:8000"
          : "https://mainnet.dfinity.network";
      console.log(host);

      // Make the request
      const result = await window.ic.plug.requestConnect({
        whitelist,
        host,
      });

      const connectionState = result ? "allowed" : "denied";
      console.log(`The Connection was ${connectionState}!`);

      // Get the user principal id
      const principalId = await window.ic.plug.agent.getPrincipal();

      console.log(`Plug's user principal Id is ${principalId}`);

      if (result) {
        router.push("/plug");
      }
    };

    return { usePlug, useStoic };
  },
};
</script>
