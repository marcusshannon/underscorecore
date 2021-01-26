const Handlebars = require("handlebars");
const fs = require("fs");
const glob = require("glob");
const path = require("path");
const watch = require("node-watch");

function getFiles() {
  return new Promise((resolve) => {
    glob("./templates/**/*.hbs", (_, templates) => {
      resolve(templates);
    });
  });
}

function getPageFiles() {
  return new Promise((resolve) => {
    glob(
      "./templates/**/*.hbs",
      { ignore: "./templates/component/**/*" },
      (_, templates) => {
        resolve(templates);
      }
    );
  });
}

function registerPartials(files) {
  files.forEach((file) => {
    const name = path.basename(file).split(".hbs")[0];
    const template = fs.readFileSync(file).toString();
    Handlebars.registerPartial(name, template);
  });
}

function compileFiles(files) {
  files.forEach((file) => {
    const basename = path.basename(file).split(".hbs")[0];
    const dirname = path.dirname(file);
    const template = fs.readFileSync(file).toString();
    fs.mkdirSync(`../lib/underscorecore_web/${dirname}`, { recursive: true });
    fs.writeFileSync(
      `../lib/underscorecore_web/${dirname}/${basename}.html.leex`,
      Handlebars.compile(template)({})
    );
  });
}

async function main() {
  const files = await getFiles();
  registerPartials(files);
  const pageFiles = await getPageFiles();
  compileFiles(pageFiles);
}

watch("./templates", { recursive: true }, () => {
  main();
});
