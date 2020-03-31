import React from "react"
import PropTypes from "prop-types"
import TrendChart from './TrendChart'

class YearInput extends React.Component {
  constructor(props) {
    super(props);
    this.handleChange = this.handleChange.bind(this);
  }

  handleChange(e) {
    this.props.onYearChange(e.target.value);
  }

  render() {
    const year = this.props.year;
    const valid = year > 1899 && year < 9999;
    const id = "trend_" + this.props.name + "_year";
    const name = "trend[" + this.props.name + "_year]";
    const classes =  "input " + (valid ? '' : "is-danger");
    return (
      <div className="field">
        <label className="label">{this.props.name} year</label>
        <p className="control has-icons-left">
          <input type="number" pattern="^[0–9]$" className={classes} min="1900"
                 step="1" maxLength="4" size="4" value={year}
                 name={name} id={id}
                 onChange={this.handleChange} />
          <span className="icon is-small is-left">
            <i className="fas fa-exclamation"></i>
          </span>
        </p>
      </div>
    );
  }
}

class NumberOfYears extends React.Component {
  constructor(props) {
    super(props)
  }

  render() {
    return (
      <div className="field">
        <label className="label">number of years</label>
        <div className="control">
          <input type="number" className="input" readOnly={true} tabIndex="-1"
                 name="trend[no_years]" id="trend_no_years"
                 placeholder="automatically calculated from start & end year"
                 value={this.props.number} />
        </div>
      </div>
    );
  }
}

class YearValuePair extends React.Component {
  constructor(props) {
    super(props)
    this.handleChange = this.handleChange.bind(this);
  }

  handleChange(e) {
    const year = document.getElementById(e.target.id.replace("value", "year")).value;
    this.props.onYearChange(year, e.target.value);
  }

  render() {
    const yearId = "trend_observations_year_" + this.props.year;
    const valueId = "trend_observations_value_" + this.props.year;

    return (
      <div className="field is-horizontal">
        <div className="field-body">
          <div className="field">
            <div className="control">
              <input className="input" readOnly={true} tabIndex="-1" type="text" value={this.props.year} id={yearId} /><br />
            </div>
          </div>

          <div className="field">
            <div className="control">
              <input className="input trend-value" step="any" type="text" value={this.props.value} id={valueId} onChange={this.handleChange} />
            </div>
          </div>
        </div>
      </div>
    );
  }
}

class TrendDataInput extends React.Component {
  constructor(props) {
    super(props)
    this.handleStartYearChange = this.handleStartYearChange.bind(this);
    this.handleEndYearChange = this.handleEndYearChange.bind(this);
    this.handleYearValueChange = this.handleYearValueChange.bind(this);
    this.calculateNumberOfYears = this.calculateNumberOfYears.bind(this);
    this.state = {
      startYear: this.props.start_year || '',
      endYear: this.props.end_year || '',
      noYears: this.props.no_years || '',
      values: this.props.values || [],
    }
  }

  updateValuePairs(startYear, endYear, noYears) {
    let updatedValues = this.state.values;

    if (this.calculateNumberOfYears(startYear, endYear) == "") {
      return updatedValues;
    }

    if (updatedValues.length == 0) {
      for (let i=0; i <= noYears - 1; i++) {
        updatedValues.push([(Number.parseInt(startYear)+i).toString(), '']);
      }
    } else {
      // add or remove pairs at the front
      let diff = Number.parseInt(updatedValues[0]) - startYear;
      if (diff > 0) {
        let newPairs = _.times(diff, (i) => [(Number.parseInt(startYear) + i).toString(), '']);
        updatedValues.unshift(...newPairs);
      } else {
        updatedValues.splice(0, Math.abs(diff));
      }

      // add or remove pairs at the back
      diff = endYear - Number.parseInt(updatedValues[updatedValues.length - 1]);
      if (diff > 0) {
        let lastYear = Number.parseInt(updatedValues[updatedValues.length - 1][0]);
        let newPairs = _.times(diff, (i) => [(lastYear + i + 1).toString(), '']);
        updatedValues.push(...newPairs);
      } else {
        updatedValues.splice(updatedValues.length - Math.abs(diff), updatedValues.length - 1);
      }
    }

    return updatedValues;
  }

  calculateNumberOfYears(startYear, endYear) {
    if (startYear < endYear && startYear > 1899 && endYear > 1899 && startYear < 9999 && endYear < 9999) {
      return endYear - startYear + 1;
    } else {
      return '';
    }
  }

  handleStartYearChange(startYear) {
    const endYear = this.state.endYear;
    let noYears = this.calculateNumberOfYears(startYear, endYear);
    let valuePairs = this.updateValuePairs(startYear, endYear, noYears);
    this.setState({
      startYear: startYear,
      noYears: noYears,
      values: valuePairs,
    });
  }

  handleEndYearChange(endYear) {
    const startYear = this.state.startYear;
    let noYears = this.calculateNumberOfYears(startYear, endYear);
    let valuePairs = this.updateValuePairs(startYear, endYear, noYears);
    this.setState({
      endYear: endYear,
      noYears: noYears,
      values: valuePairs,
    });
  }

  handleYearValueChange(year, value) {
    let values = this.state.values.map((pair) => {
      if (pair[0] == year) {
        return [year, value]
      } else {
        return pair
      }
    });
    this.setState({ values: values });
  }

  render() {
    const yearValuePairs = this.state.values;

    const yearValueInputs = this.state.values.map((pair) =>
      <YearValuePair key={pair[0]} year={pair[0]} value={pair[1]}
                     onYearChange={this.handleYearValueChange} />
    );

    const showHelptext = this.state.startYear !== "" && this.state.endYear !== "";
    const helpMessage = (
      <div className="columns">
        <div className="column">
          <p className="help">Please enter start and end years.</p>
        </div>
      </div>
    );
    const inputAndChart = (
      <div className="columns">
        <div className="column is-one-quarter">
          {yearValueInputs}
        </div>
        <div className="column">
          <TrendChart observations={yearValuePairs} />
        </div>
      </div>
    );

    const jsonValues = JSON.stringify(this.state.values);

    return (
      <div className="trend-data-input">
        <h3 className="subtitle is-4 is-spaced"> Observations </h3>

        <div className="columns">
          <div className="column">
            <YearInput name="start" year={this.state.startYear} onYearChange={this.handleStartYearChange} />

            <YearInput name="end" year={this.state.endYear} onYearChange={this.handleEndYearChange} />
          </div>


          <div className="column">
            <NumberOfYears number={this.state.noYears} />
          </div>
        </div>

        <h4 className="subtitle is-5 is-spaced"> Values </h4>

        {showHelptext ? inputAndChart : helpMessage}

        <input name="trend[trend_observations_attributes]" type="hidden" value={jsonValues} />
      </div>
    );
  }
}

TrendDataInput.propTypes = {
  start_year: PropTypes.number,
  end_year: PropTypes.number,
  values: PropTypes.array
};
export default TrendDataInput
