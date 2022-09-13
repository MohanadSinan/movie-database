package com.example.javabelt.repositories;

import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import com.example.javabelt.models.Rate;

@Repository
public interface RateRepository extends CrudRepository<Rate, Long> {

	

}
