<template>

      <ol>
        <li v-for="counter in counters">
          <button v-on:click="counter.value = Number(counter.value) + 1">up</button> | {{counter.value}} {{counter.name}}
          <input v-model="counter.value" type="number">
          <input v-model="counter.color" type="color">
          <input v-model="counter.value" type="range" min="0" max="120" step="1">
        </li>
      </ol>
    </div>
    <p>
      the sorting happens in javascript
    </p>
    <p>
      few highlights and a different texture on the same tone
    </p>

</template>
<script>

onChange(sort)
var app = new Vue({
  el: '#app',
  data: {
    message: 'You loaded this page on ' + new Date().toLocaleString(),
    seen: true,
    counters: [{ name: "pit", value: 0 }, { name: "questions", value: 5 }],
  },
  methods: {
    sort: function () { counters.sort((element) => { return element.value; }); }
  }
})

</script>
<style>
    
.body {
 background-color: darker;
}
.face {
}
.eyes {
}
    
</style>
