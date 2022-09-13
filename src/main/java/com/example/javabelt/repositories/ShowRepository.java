package com.example.javabelt.repositories;

import java.util.List;
import java.util.Optional;

import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import com.example.javabelt.models.Show;

@Repository
public interface ShowRepository extends CrudRepository<Show, Long>{

	Optional<Show> findByTitle(String title);
	Optional<Show> findById(Long id);
	List<Show> findAll();
}
