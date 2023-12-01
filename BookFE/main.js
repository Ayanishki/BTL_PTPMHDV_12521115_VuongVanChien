const hours = document.getElementById("hours");
const minutes = document.getElementById("minutes");
const seconds = document.getElementById("seconds");

const minutetimer = 180;
var countdownTime = minutetimer * 60;
function Countdown() {
  const h = Math.floor(countdownTime / 3600);
  const m = Math.floor(countdownTime / 60) % 60;
  const s = countdownTime % 60;
  hours.innerHTML = h < 10 ? '0' + h :h;
  minutes.innerHTML = m < 10 ? '0' + m :m;
  seconds.innerHTML = s < 10 ? '0' + s :s;
  countdownTime--;
  // if (countdownTime = 0){  
  //   hours.innerHTML = '00';
  //   minutes.innerHTML = '00';
  //   seconds.innerHTML = '00';
  // }
  // else {
  //   hours.innerHTML = h < 10 ? '0' + h :h;
  //   minutes.innerHTML = m < 10 ? '0' + m :m;
  //   seconds.innerHTML = s < 10 ? '0' + s :s;
  // }
}
setInterval(Countdown,1000);
