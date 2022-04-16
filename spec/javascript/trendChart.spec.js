import React from "react";
import { render, screen } from "@testing-library/react";
// This needs to be available to every test file that uses document methods like 'toBeInTheDocument'
import "@testing-library/jest-dom";
import TrendChart from "../../app/javascript/components/TrendChart";

const mockObervations = [
	["1963", "18.364221556248"],
	["1964", "16.7151766797256"],
];
test("Renders TrendChart component", () => {
	render(<TrendChart observations={mockObervations} />);
	const chart = screen.getByTestId("trend-chart");
	expect(chart).toBeInTheDocument();
	console.log("TrendChart is in document");
});
