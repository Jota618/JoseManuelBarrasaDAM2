# jocarsa-mistyrose

# jocarsa-mistyrose

A lightweight JavaScript library for creating beautiful and customizable pie charts and bar charts. The library is designed to be simple to use and provides a soft pastel color palette for a visually appealing experience.

## Features

- **Pie Charts**: Create interactive pie charts with hover effects and labels.
- **Bar Charts**: Generate bar charts with customizable bars, labels, and values.
- **Soft Color Palette**: Automatically generates a consistent and visually pleasing color scheme.
- **Responsive Design**: Charts are responsive and adapt to the container size.
- **Easy to Use**: Simple API for quick integration into your projects.

## Installation

To use `jocarsa-mistyrose`, include the JavaScript and CSS files in your HTML:

```html
<!-- Include the CSS file -->
<link rel="stylesheet" href="https://jocarsa.github.io/jocarsa-mistyrose/jocarsa%20%7C%20mistyrose.css">

<!-- Include the JavaScript file -->
<script src="https://jocarsa.github.io/jocarsa-mistyrose/jocarsa%20%7C%20mistyrose.js"></script>
```

## Usage

### Creating a Pie Chart

To create a pie chart, initialize a new `Chart` instance with a container selector and data:

```javascript
const data = [
    { label: "Apples", value: 30 },
    { label: "Oranges", value: 50 },
    { label: "Bananas", value: 20 }
];

const chart = new jocarsaMistyrose.Chart("#pie-chart-container", data);
chart.createPieChart(document.querySelector("#pie-chart-container"));
```

### Creating a Bar Chart

To create a bar chart, initialize a new `Chart` instance with a container selector and data:

```javascript
const data = [
    { label: "Q1", value: 100 },
    { label: "Q2", value: 200 },
    { label: "Q3", value: 150 },
    { label: "Q4", value: 300 }
];

const chart = new jocarsaMistyrose.Chart("#bar-chart-container", data);
chart.createBarChart(document.querySelector("#bar-chart-container"));
```

### HTML Structure

Ensure your HTML has the appropriate container elements:

```html
<div id="pie-chart-container"></div>
<div id="bar-chart-container"></div>
```

## Customization

### CSS Styling

The library applies a default style to the chart containers using the `.jocarsa-mistyrose` class. You can override these styles in your own CSS:

```css
.jocarsa-mistyrose {
    display: flex;
    align-items: center;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
    border-radius: 8px;
    background-color: #fff;
    padding: 20px;
    width: 500px;
    margin: 20px;
}
```

### Chart Options

The library currently supports basic customization through the `Chart` class constructor. You can extend the functionality by modifying the library code.

## Examples

You can view live examples and explore the library's capabilities on the [GitHub Pages site](https://jocarsa.github.io/jocarsa-mistyrose/).

## Contributing

Contributions are welcome! If you'd like to contribute, please fork the repository and submit a pull request. For major changes, please open an issue first to discuss the proposed changes.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Inspired by the need for simple, lightweight charting solutions.
- Built with vanilla JavaScript and CSS for maximum compatibility.

---

Enjoy using `jocarsa-mistyrose`! If you have any questions or feedback, feel free to open an issue on the [GitHub repository](https://github.com/jocarsa/jocarsa-mistyrose).
