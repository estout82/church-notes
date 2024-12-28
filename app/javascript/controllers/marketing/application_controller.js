
import {Controller} from "@hotwired/stimulus";
import Chart from "chart.js/auto";

export default class extends Controller {
  static targets = ["scroll", "nav", "redirect", "noteViewsChart", "noteViewsChartData"];

  noteViewsChartTargetConnected() {
    const labels = JSON.parse(
      this
        .noteViewsChartDataTarget
        .getAttribute("data-labels")
    );

    const values = JSON.parse(
      this
        .noteViewsChartDataTarget
        .getAttribute("data-values")
    );

    const data = {
      labels: labels,
      datasets: [{
        label: "Views",
        backgroundColor: "#7986cb",
        borderColor: "#7986cb",
        data: values,
        tension: 0.3
      }]
    };
  
    const config = {
      type: "line",
      data: data,
      options: {
        scales: {
          y: {
            suggestedMax: 10,
            min: 0
          }
        }
      }
    };  

    new Chart(this.noteViewsChartTarget, config);
  }

  redirectTargetConnected(element) {
    window.open(element.getAttribute("data-href"), '_blank').focus();
  }

  scrollTargetConnected(element) {
    element.addEventListener("scroll", this.handleScroll.bind(this));
  }

  handleScroll(event) {
    const scrolled = event.target.scrollTop > 0;

    if (scrolled) {
      this.styleNav();
    } else {
      this.unstyleNav();
    }
  }

  styleNav() {
    this.navTarget.classList.toggle("backdrop-blur-lg", true);
    this.navTarget.classList.toggle("border-b", true);
    this.navTarget.classList.toggle("border-slate-200", true);
    this.navTarget.classList.toggle("bg-slate-100/70", true);
  }

  unstyleNav() {
    this.navTarget.classList.toggle("backdrop-blur-lg", false);
    this.navTarget.classList.toggle("border-b", false);
    this.navTarget.classList.toggle("border-slate-200", false);
    this.navTarget.classList.toggle("bg-slate-100/70", false);
  }
}
