package com.example.javabelt.services;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import com.example.javabelt.models.Rate;
import com.example.javabelt.models.RateRequest;
import com.example.javabelt.models.Show;
import com.example.javabelt.models.User;
import com.example.javabelt.repositories.RateRepository;
import com.example.javabelt.repositories.ShowRepository;

@Service
public class RateService {
	@Autowired
	RateRepository rateRepository;
	
	
	
	public List<Rate> getRates(Show show){
	      return show.getRate();
	}
	
	public Rate addRate(Show show, RateRequest rateRequest, User user) {
		Rate rate = new Rate();
		rate.setRate(rateRequest.getRate());
		rate.setShow(show);
		rate.setUser(user);
		
//		show.getRate().add(rate)
//		showRepo.save(show)
		return rateRepository.save(rate);
	}
	
	public void getAvg(List<Show> show) {
		
		for (Show myShow : show) {
		List<Rate> rates = myShow.getRate();
		double sum = 0;
		for (Rate  t : rates)  {
			sum += t.getRate();
		}
		
	  double avg =	sum / rates.size();
	  myShow.setAvg(avg);
	}
		
		
}
}
