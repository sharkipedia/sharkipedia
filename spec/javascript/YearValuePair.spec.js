import React from "react";
import { render, screen } from "@testing-library/react";
import "@testing-library/jest-dom";
import YearValuePair from "../../app/javascript/components/YearValuePair";

test("Should see year input", () => {
	render(<YearValuePair year={"1999"} value={""} />);
	const yearInput = screen.getByLabelText("year");
	expect(yearInput).toBeInTheDocument();
});

test("Should see value input", () => {
	render(<YearValuePair year={"1999"} value={""} />);
	const valueInput = screen.getByLabelText("value");
	expect(valueInput).toBeInTheDocument();
});

test("Year input should display year passed as year prop", () => {
	render(<YearValuePair year={"1999"} value={""} />);
	const yearInput = screen.getByLabelText("year");
	expect(yearInput.value).toBe("1999");
});

test("Value input should display value", () => {
	render(<YearValuePair year={"1999"} value={"22"} />);
	const valueInput = screen.getByLabelText("value");
	expect(valueInput.value).toBe("22");
});
