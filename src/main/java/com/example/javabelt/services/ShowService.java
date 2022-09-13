package com.example.javabelt.services;

import java.util.List;
import java.util.Optional;

import javax.crypto.ShortBufferException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.ModelAttribute;

import com.example.javabelt.models.Show;
import com.example.javabelt.repositories.ShowRepository;

@Service
public class ShowService {
	@Autowired
    ShowRepository showRepository;

	public Show create(Show show) {
		return showRepository.save(show);
	}
	
	public Show findByTitle(String title) {
		Optional<Show> optionalShow = showRepository.findByTitle(title);
		if (optionalShow.isPresent()) {
			return optionalShow.get();
		} else {
			return null;
		}
	}
	
	public Show findById(Long id) {
		Optional<Show> optionalShow = showRepository.findById(id);
		if (optionalShow.isPresent()) {
			return optionalShow.get();
		} else {
			return null;
		}
	}

	public List<Show> findAll() {
		return showRepository.findAll();
	}
	
	public Show updateShow(Long id, @ModelAttribute("show") Show show) {
		if(findById(id) == null) {
			return null;
		}else{
			Optional<Show> optionalShow = showRepository.findById(id);
			Show show2 = optionalShow.get();
			show2.setTitle(show.getTitle());
			show2.setNetwork(show.getNetwork());
			show2.setDescription(show.getDescription());
			
			return showRepository.save(show2);
		}
		
		
	
	}

	public void deleteById(Long id) {
		Show optionalShow = showRepository.findById(id).get();
		showRepository.delete(optionalShow);
		
	}

	
}
