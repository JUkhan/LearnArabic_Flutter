//  copyright lexilogos.com

function alpha(item) {
  var input = document.conversion.saisie;
  if (document.selection) {
    input.focus();
    range = document.selection.createRange();
    range.text = item;
    range.select();
  } else if (input.selectionStart || input.selectionStart === "0") {
    var startPos = input.selectionStart;
    var endPos = input.selectionEnd;
    var cursorPos = startPos;
    var scrollTop = input.scrollTop;
    var baselength = 0;
    input.value =
      input.value.substring(0, startPos) +
      item +
      input.value.substring(endPos, input.value.length);
    cursorPos += item.length;
    input.focus();
    input.selectionStart = cursorPos;
    input.selectionEnd = cursorPos;
    input.scrollTop = scrollTop;
  } else {
    input.value += item;
    input.focus();
  }
}

function copier() {
  document.conversion.saisie.focus();
  document.conversion.saisie.select();
  copietxt = document.selection.createRange();
  copietxt.execCommand("Copy");
}

var car;
function keyDownn(e) {
  if (e.shiftKey == false && e.keyCode >= 49 && e.keyCode <= 57) {
    if (e.key == "1") {
      alpha("\u064E");
    } else if (e.key == "2") {
      alpha("\u064F");
    } else if (e.key == "3") {
      alpha("\u0650");
    } else if (e.key == "4") {
      alpha("\u064B");
    } else if (e.key == "5") {
      alpha("\u064C");
    } else if (e.key == "6") {
      alpha("\u064D");
    } else if (e.key == "7") {
      alpha("\u0651");
    } else if (e.key == "8") {
      alpha("\u0652");
    }
    e.preventDefault();
    return true;
  }
}
var isRemovedChar = false;
function transcrire(e) {
  console.log(e);
  var input = document.conversion.saisie;
  var cursorPos = input.selectionStart;
  var scrollTop = input.scrollTop;
  if (e.shiftKey == false && e.keyCode >= 49 && e.keyCode <= 57) {
    return;
  }
  car = document.conversion.saisie.value;

  car = car.replace(/’/g, "'");
  car = car.replace(/[aâàā]/g, "ا");
  car = car.replace(/اا/g, "آ");
  car = car.replace(/b/g, "ب");
  car = car.replace(/ب'/g, "پ");
  car = car.replace(/p/g, "پ");
  car = car.replace(/پ'/g, "ب");
  car = car.replace(/t/g, "ت");
  car = car.replace(/ت'/g, "ث");
  car = car.replace(/ث'/g, "ت");
  car = car.replace(/ṯ/g, "ث");
  car = car.replace(/[jǧ]/g, "ج");
  car = car.replace(/ج'/g, "چ");
  car = car.replace(/c/g, "چ");
  car = car.replace(/چ'/g, "ح");
  car = car.replace(/[HḥḤ]/g, "ح");
  car = car.replace(/ح'/g, "خ");
  car = car.replace(/[xẖK]/g, "خ");
  car = car.replace(/خ'/g, "ج");
  car = car.replace(/d/g, "د");
  car = car.replace(/د'/g, "ذ");
  car = car.replace(/ذ'/g, "د");
  car = car.replace(/ḏ/g, "ذ");
  car = car.replace(/r/g, "ر");
  car = car.replace(/ر'/g, "ز");
  car = car.replace(/ز'/g, "ر");
  car = car.replace(/z/g, "ز");
  car = car.replace(/s/g, "س");
  car = car.replace(/س'/g, "ش");
  car = car.replace(/ش'/g, "س");
  car = car.replace(/š/g, "ش");
  car = car.replace(/[Sṣ]/g, "ص");
  car = car.replace(/ص'/g, "ض");
  car = car.replace(/ض'/g, "ص");
  car = car.replace(/[Dḍ]/g, "ض");
  car = car.replace(/[Tṭ]/g, "ط");
  car = car.replace(/ط'/g, "ظ");
  car = car.replace(/ظ'/g, "ط");
  car = car.replace(/[Zẓ]/g, "ظ");
  car = car.replace(/[gʿ]/g, "ع");
  car = car.replace(/ع'/g, "غ");
  car = car.replace(/غ'/g, "ع");
  car = car.replace(/ġ/g, "غ");
  car = car.replace(/f/g, "ف");
  car = car.replace(/ف'/g, "ڤ");
  car = car.replace(/ڤ'/g, "ف");
  car = car.replace(/v/g, "ڢ");
  car = car.replace(/q/g, "ق");
  car = car.replace(/ق'/g, "ڨ");
  car = car.replace(/ڨ'/g, "ق");
  car = car.replace(/k/g, "ك");
  car = car.replace(/ك'/g, "ڭ");
  car = car.replace(/ڭ'/g, "ك");
  car = car.replace(/l/g, "ل");
  car = car.replace(/m/g, "م");
  car = car.replace(/n/g, "ن");
  car = car.replace(/h/g, "ه");
  car = car.replace(/ه'/g, "ة");
  car = car.replace(/ة'/g, "ه");
  car = car.replace(/[wouôûōū]/g, "و");
  car = car.replace(/[yieîī]/g, "ي");
  car = car.replace(/[YIE]/g, "ى");
  car = car.replace(/ي'/g, "ى");
  car = car.replace(/ى'/g, "ي");
  car = car.replace(/-/g, "ء");
  car = car.replace(/ʾ/g, "ء");
  car = car.replace(/وءء/g, "ؤ");
  car = car.replace(/يءء/g, "ئ");
  car = car.replace(/اءء/g, "إ");
  car = car.replace(/I/g, "إ");
  car = car.replace(/A/g, "إ");
  car = car.replace(/ءا/g, "أ");
  car = car.replace(/_/g, "ـ");
  car = car.replace(/\?/g, "؟");
  car = car.replace(/\;/g, "؛");
  car = car.replace(/\,/g, "،");

  document.conversion.saisie.value = car;

  if (e.key == "Backspace") {
    isRemovedChar = true;
  } else if (e.key == "'") {
    cursorPos--;
  } else if (
    e.key == "ArrowRight" ||
    e.key == "ArrowLeft" ||
    e.key == "ArrowUp" ||
    e.key == "ArrowDown"
  ) {
  } else {
    if (isRemovedChar) {
      isRemovedChar = false;
      //cursorPos--;
    }
    //cursorPos++;
  }
  input.focus();
  input.selectionStart = cursorPos;
  input.selectionEnd = cursorPos;
  input.scrollTop = scrollTop;
}

document.addEventListener("DOMContentLoaded", function (event) {
  document.getElementById("bar").value = localStorage.getItem("raw") || "";
  new ClipboardJS("#mapcopy", {
    text: function (trigger) {
      console.log("------maping row data------");
      return map();
    },
  });
});

function map() {
  var res,
    foundBeginQuote,
    str = document.getElementById("bar").value;
  localStorage.setItem("raw", str);
  var isQA = str.includes("$");
  var arr = str.split("\n").filter((it) => it != "");
  if (isQA) {
    res = arr.map((line) => {
      var qa = line.split("$");
      return { words: [{ w: qa[0], e: qa[1] }] };
    });
  } else {
    res = arr.map((line) => {
      return {
        words: line
          .split(/\s+/g)
          .filter((it) => it != "")
          .reduce((arr, item) => {
            var len = arr.length - 1;
            if (item.startsWith("'")) {
              foundBeginQuote = true;
              arr.push(item.substr(1));
            } else if (item.endsWith("'")) {
              foundBeginQuote = false;
              arr[len] = arr[len] + " " + item.substr(0, item.length - 1);
            } else if (foundBeginQuote) arr[len] = arr[len] + " " + item;
            else arr.push(item);
            return arr;
          }, [])
          .map((w) => ({ w, e: "" })),
      };
    });
  }
  console.log(JSON.stringify(res, null, 2));
  return res.map((_) => JSON.stringify(_)).join(",\n");
}
