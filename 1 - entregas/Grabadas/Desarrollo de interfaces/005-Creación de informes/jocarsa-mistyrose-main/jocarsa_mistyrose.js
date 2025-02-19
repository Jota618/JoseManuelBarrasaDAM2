// Namespace for the library
const jocarsaMistyrose = (function () {
    // Chart class
    class Chart {
        constructor(containerSelector, data) {
            this.containers = document.querySelectorAll(containerSelector);
            this.data = data;
            this.colors = this.generateColors(data.length);
            this.init();
        }

        // Initialize the chart for each container
        init() {
            this.containers.forEach(container => {
                container.classList.add("jocarsa-mistyrose"); // Add class to container
            });
        }

        // Generate a soft color palette
        generateColors(count) {
            const colors = [];
            const baseHue = Math.random() * 360; // Random base hue for consistency
            for (let i = 0; i < count; i++) {
                const hue = (baseHue + (i * 360 / count)) % 360; // Distribute hues evenly
                colors.push(`hsl(${hue}, 60%, 70%)`); // Soft pastel colors
            }
            return colors;
        }

        // Convert data to percentages
        calculatePercentages(data) {
            const total = data.reduce((sum, item) => sum + item.value, 0);
            return data.map(item => ({
                ...item,
                percentage: (item.value / total) * 100
            }));
        }

        // Create SVG element
        createSVG(width, height) {
            const svg = document.createElementNS("http://www.w3.org/2000/svg", "svg");
            svg.setAttribute("width", width);
            svg.setAttribute("height", height);
            svg.setAttribute("viewBox", `0 0 ${width} ${height}`);
            return svg;
        }

        // Create a pie chart
        createPieChart(container) {
            const width = 300;
            const height = 300;
            const radius = Math.min(width, height) / 2 - 20; // Add padding to prevent cropping

            const svg = this.createSVG(width, height);
            const g = document.createElementNS("http://www.w3.org/2000/svg", "g");
            g.setAttribute("transform", `translate(${width / 2}, ${height / 2})`);

            const dataWithPercentages = this.calculatePercentages(this.data);
            let startAngle = 0;

            dataWithPercentages.forEach((item, index) => {
                const slice = document.createElementNS("http://www.w3.org/2000/svg", "path");
                const endAngle = startAngle + (item.percentage / 100) * 360;

                const x1 = radius * Math.cos((Math.PI * startAngle) / 180);
                const y1 = radius * Math.sin((Math.PI * startAngle) / 180);
                const x2 = radius * Math.cos((Math.PI * endAngle) / 180);
                const y2 = radius * Math.sin((Math.PI * endAngle) / 180);

                const largeArcFlag = item.percentage > 50 ? 1 : 0;

                const pathData = `
                    M 0 0
                    L ${x1} ${y1}
                    A ${radius} ${radius} 0 ${largeArcFlag} 1 ${x2} ${y2}
                    Z
                `;

                slice.setAttribute("d", pathData);
                slice.setAttribute("fill", this.colors[index]);
                slice.setAttribute("stroke", "#fff");
                slice.setAttribute("stroke-width", "2");
                slice.setAttribute("data-label", item.label);
                slice.setAttribute("data-percentage", item.percentage.toFixed(2));
                slice.style.transition = "transform 0.2s ease, stroke-width 0.2s ease"; // Smooth transition

                // Add hover effect
                slice.addEventListener("mouseenter", () => {
                    slice.setAttribute("stroke-width", "4"); // Thicker border on hover
                    slice.setAttribute("transform", "scale(1.05)"); // Slight scale-up
                });
                slice.addEventListener("mouseleave", () => {
                    slice.setAttribute("stroke-width", "2"); // Restore border
                    slice.setAttribute("transform", "scale(1)"); // Restore size
                });

                g.appendChild(slice);

                // Add label to the slice
                const midAngle = (startAngle + endAngle) / 2;
                const labelRadius = radius * 0.8; // Position labels slightly inside the slice
                const labelX = labelRadius * Math.cos((Math.PI * midAngle) / 180);
                const labelY = labelRadius * Math.sin((Math.PI * midAngle) / 180);

                const label = document.createElementNS("http://www.w3.org/2000/svg", "text");
                label.setAttribute("x", labelX);
                label.setAttribute("y", labelY);
                label.setAttribute("text-anchor", "middle");
                label.setAttribute("fill", "#333"); // Darker text for better contrast
                label.setAttribute("font-size", "12px");
                label.setAttribute("font-family", "Arial, sans-serif");
                label.setAttribute("pointer-events", "none"); // Prevent label from blocking hover
                label.textContent = `${item.label} (${item.percentage.toFixed(2)}%)`;

                g.appendChild(label);

                startAngle = endAngle;
            });

            svg.appendChild(g);
            container.appendChild(svg);

            // Add legend
            this.createLegend(container, dataWithPercentages);
        }

        // Create a bar chart with a legend
        createBarChart(container) {
            const width = 400;
            const height = 300;
            const barWidth = 40;
            const barSpacing = 20;
            const maxValue = Math.max(...this.data.map(item => item.value));

            const svg = this.createSVG(width, height);
            const g = document.createElementNS("http://www.w3.org/2000/svg", "g");
            g.setAttribute("transform", `translate(50, 20)`); // Add padding

            // Calculate percentages for the data
            const dataWithPercentages = this.calculatePercentages(this.data);

            dataWithPercentages.forEach((item, index) => {
                const barHeight = (item.value / maxValue) * (height - 50); // Scale bars to fit height
                const x = index * (barWidth + barSpacing);
                const y = height - 50 - barHeight;

                // Draw bar
                const bar = document.createElementNS("http://www.w3.org/2000/svg", "rect");
                bar.setAttribute("x", x);
                bar.setAttribute("y", y);
                bar.setAttribute("width", barWidth);
                bar.setAttribute("height", barHeight);
                bar.setAttribute("fill", this.colors[index]);
                bar.style.transition = "fill 0.2s ease";

                // Add hover effect
                bar.addEventListener("mouseenter", () => {
                    bar.setAttribute("fill", "hsl(0, 0%, 80%)"); // Highlight on hover
                });
                bar.addEventListener("mouseleave", () => {
                    bar.setAttribute("fill", this.colors[index]); // Restore color
                });

                g.appendChild(bar);

                // Add label below the bar
                const label = document.createElementNS("http://www.w3.org/2000/svg", "text");
                label.setAttribute("x", x + barWidth / 2);
                label.setAttribute("y", height - 30);
                label.setAttribute("text-anchor", "middle");
                label.setAttribute("fill", "#333");
                label.setAttribute("font-size", "12px");
                label.setAttribute("font-family", "Arial, sans-serif");
                label.textContent = item.label;

                g.appendChild(label);

                // Add value above the bar
                const value = document.createElementNS("http://www.w3.org/2000/svg", "text");
                value.setAttribute("x", x + barWidth / 2);
                value.setAttribute("y", y - 5);
                value.setAttribute("text-anchor", "middle");
                value.setAttribute("fill", "#333");
                value.setAttribute("font-size", "12px");
                value.setAttribute("font-family", "Arial, sans-serif");
                value.textContent = item.value;

                g.appendChild(value);
            });

            svg.appendChild(g);
            container.appendChild(svg);

            // Add legend to the bar chart
            this.createLegend(container, dataWithPercentages);
        }

        // Create a legend
        createLegend(container, data) {
            const legend = document.createElement("div");
            legend.style.marginLeft = "20px";
            legend.style.fontFamily = "Arial, sans-serif";
            legend.style.fontSize = "14px";

            data.forEach((item, index) => {
                const legendItem = document.createElement("div");
                legendItem.style.display = "flex";
                legendItem.style.alignItems = "center";
                legendItem.style.marginBottom = "8px";

                const colorSquare = document.createElement("div");
                colorSquare.style.width = "12px";
                colorSquare.style.height = "12px";
                colorSquare.style.backgroundColor = this.colors[index];
                colorSquare.style.marginRight = "8px";

                const labelText = document.createElement("span");
                labelText.textContent = `${item.label}: ${item.value} (${item.percentage ? item.percentage.toFixed(2) + "%" : ""})`;

                legendItem.appendChild(colorSquare);
                legendItem.appendChild(labelText);
                legend.appendChild(legendItem);
            });

            container.appendChild(legend);
        }

// Add the createLineChart function to the Chart class
createLineChart(container) {
    const width = 400;
    const height = 300;
    const padding = 30;
    const maxValue = Math.max(...this.data.map(item => item.value));

    const svg = this.createSVG(width, height);
    const g = document.createElementNS("http://www.w3.org/2000/svg", "g");
    g.setAttribute("transform", `translate(${padding}, 20)`);

    const dataWithPercentages = this.calculatePercentages(this.data);

    // Create the line path
    const line = document.createElementNS("http://www.w3.org/2000/svg", "path");
    let pathData = "M 0 " + (height - padding - (dataWithPercentages[0].value / maxValue) * (height - 50)); // Start at the first point

    dataWithPercentages.forEach((item, index) => {
        const x = index * (width / this.data.length);
        const y = height - padding - (item.value / maxValue) * (height - 50); // Scale the y value

        pathData += ` L ${x} ${y}`;
    });

    line.setAttribute("d", pathData);
    line.setAttribute("fill", "none");
    line.setAttribute("stroke", "#4caf50"); // Line color
    line.setAttribute("stroke-width", "2");

    g.appendChild(line);

    // Add circles for each point
    dataWithPercentages.forEach((item, index) => {
        const x = index * (width / this.data.length);
        const y = height - padding - (item.value / maxValue) * (height - 50);

        const circle = document.createElementNS("http://www.w3.org/2000/svg", "circle");
        circle.setAttribute("cx", x);
        circle.setAttribute("cy", y);
        circle.setAttribute("r", "5");
        circle.setAttribute("fill", this.colors[index]);

        // Add hover effect on circles
        circle.addEventListener("mouseenter", () => {
            circle.setAttribute("r", "7"); // Increase radius on hover
        });
        circle.addEventListener("mouseleave", () => {
            circle.setAttribute("r", "5"); // Restore original radius
        });

        g.appendChild(circle);
    });

    svg.appendChild(g);
    container.appendChild(svg);

    // Add legend
    this.createLegend(container, dataWithPercentages);
}



    }



    
    // Expose the Chart class
    return {
        Chart: Chart
    };
})();
