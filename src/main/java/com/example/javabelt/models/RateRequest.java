package com.example.javabelt.models;

import org.hibernate.validator.constraints.Range;

public class RateRequest {
	@Range(min = (long) 1.0, max = (long) 5.0)
	private double rate;

	public double getRate() {
		return rate;
	}

	public void setRate(double rate) {
		this.rate = rate;
	}
	
	
}
