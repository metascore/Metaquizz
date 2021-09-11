<template>
  <div class="flex flex-col h-70 justify-center items-center">
    <div id="parent">
      <img src="../../assets/Motoko.png" alt="" id="anim" />
      <img
        src="../../assets/Motoko.png"
        alt=""
        id="anim2"
        class="absolute top-100"
      />
    </div>
    <div class="flex flex-row gap-x-5">
      <div>
        <h1 class="text-5xl font-indie text-gray-700">Loading</h1>
      </div>
      <div class="flex flex-row items-center justify-center gap-x-1">
        <div class="dot bg-gray-700"></div>
        <div class="dot bg-gray-700"></div>
        <div class="dot bg-gray-700"></div>
        <div class="dot bg-gray-700"></div>
        <div class="dot bg-gray-700"></div>
      </div>
    </div>
  </div>
</template>

<script>
import { defineComponent } from "vue";
export default defineComponent({
  setup() {},
});
</script>

<style scoped>
.dot {
  height: 12px;
  width: 12px;
  border-radius: 50%;
  animation: scaling 2s ease-in-out infinite;
}
.dot:nth-child(1) {
  animation-delay: 0s;
}
.dot:nth-child(2) {
  animation-delay: 0.2s;
}
.dot:nth-child(2) {
  animation-delay: 0.4s;
}
.dot:nth-child(3) {
  animation-delay: 0.6s;
}
.dot:nth-child(4) {
  animation-delay: 0.8s;
}
.dot:nth-child(5) {
  animation-delay: 1s;
}
img {
  transform: scale(0.5, 0.5);
}
#parent {
  position: relative;
  top: 0;
  left: 0;
  z-index: -100;
}
#anim {
  animation: motoko 6s ease-in-out infinite;
  position: relative;
  top: 0;
  left: 0;
}
#anim2 {
  animation: motoko2 6s ease-in-out infinite;
  position: absolute;
  top: -30px;
  left: 0;
}
@keyframes motoko {
  0% {
    opacity: 0;
  }
  25% {
    opacity: 1;
  }
  50% {
    opacity: 0;
  }
  75% {
    opacity: 0;
  }
  100% {
    opacity: 0;
  }
}
@keyframes motoko2 {
  0% {
    opacity: 0;
  }
  25% {
    opacity: 0;
  }
  50% {
    opacity: 0;
  }
  75% {
    opacity: 1;
  }
  100% {
    opacity: 0;
  }
}
@keyframes scaling {
  0%,
  100% {
    transform: scale(0.4);
  }
  40% {
    transform: scale(1);
  }
  50% {
    transform: scale(1);
  }
}
</style>
