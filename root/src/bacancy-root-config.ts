import { registerApplication, start } from "single-spa";
import {
  constructApplications,
  constructRoutes,
  constructLayoutEngine,
} from "single-spa-layout";
import microfrontendLayout from "./microfrontend-layout.html";

const routes = constructRoutes(microfrontendLayout);
console.log(routes)
const applications = constructApplications({
  routes,
  loadApp({ name }) {
    console.log(name)
    return System.import(name);
  },
});
console.log(applications)
const layoutEngine = constructLayoutEngine({ routes, applications });
console.log(layoutEngine)
applications.forEach(registerApplication);
layoutEngine.activate();
start();
