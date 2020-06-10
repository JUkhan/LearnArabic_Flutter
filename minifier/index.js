var fs = require("fs");

function readInput(filename) {
  var text = fs.readFileSync(filename).toString();
  var data = JSON.parse(text);

  fs.writeFileSync(filename, JSON.stringify(data));

  console.info(`${filename} - done`);
}

const { resolve } = require("path");
const { readdir } = require("fs").promises;

async function getFiles(dir) {
  const dirents = await readdir(dir, { withFileTypes: true });
  const files = await Promise.all(
    dirents.map((dirent) => {
      const res = resolve(dir, dirent.name);
      return dirent.isDirectory() ? getFiles(res) : res;
    })
  );
  return Array.prototype.concat(...files);
}
getFiles(
  "/Users/jukhan/Documents/flutter-apps/LearnArabic_Flutter/learn_arabic/assets/book2"
)
  .then((files) =>
    files.map((file) => {
      file.endsWith(".json") && readInput(file);
    })
  )
  .catch((e) => console.error(e));
