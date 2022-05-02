import React from "react";

const YearValuePair = (props) => {
	const handleChange = (e) => {
		const year = document.getElementById(e.target.id.replace("value", "year")).value;
		props.onYearChange(year, e.target.value);
	};

	const yearId = "trend_observations_year_" + props.year;
	const valueId = "trend_observations_value_" + props.year;

	return (
		<div className='field is-horizontal'>
			<div className='field-body'>
				<div className='field'>
					<div className='control'>
						<input className='input' readOnly={true} tabIndex='-1' aria-label='year' type='text' value={props.year} id={yearId} />
						<br />
					</div>
				</div>

				<div className='field'>
					<div className='control'>
						<input
							className='input trend-value'
							step='any'
							aria-label='value'
							type='text'
							value={props.value}
							id={valueId}
							onChange={handleChange}
						/>
					</div>
				</div>
			</div>
		</div>
	);
};

export default YearValuePair;
