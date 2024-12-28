/**
 * Client-side functionality for the analytics widget
 */

import {Controller} from "@hotwired/stimulus";
import Chart from "chart.js/auto";

export default class extends Controller {
  static targets = ["viewsChart", "viewsChartData"];

  connect() {
    const labels = JSON.parse(
      this
        .viewsChartDataTarget
        .getAttribute("data-labels")
    );

    const values = JSON.parse(
      this
        .viewsChartDataTarget
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

    new Chart(this.viewsChartTarget, config);
  }
}
