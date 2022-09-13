package com.example.javabelt.models;


import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.Table;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.Pattern;
import javax.validation.constraints.Size;


import java.util.*;

@Entity
@Table(name = "shows")
public class Show {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;

	
	@NotBlank(message = "title is required!")
	@Size(min = 3, max = 30, message = "title must be between 3 and 30 characters")
	private String title;

	@Pattern(regexp = "^[A-Za-z]*$", message = "Invalid network Name ,Please enter letters only")
	@NotBlank(message = "network is required!")
	@Size(min = 3, max = 30, message = "network must be between 3 and 30 characters")
	private String network;

	@NotBlank(message = "description is required!")
	@Size(min = 8, max = 128, message = "description must be between 8 and 128 characters")
	private String description;
	
    private String postedBy;
	
	@OneToMany(mappedBy = "show", fetch = FetchType.LAZY,cascade =CascadeType.ALL)
	private List<Rate> rate;

	private double avg;
	
	public void setAvg(double num) {
		 this.avg = num;
		
	}
	
	public double getAvg() {
		return this.avg;
	}
	
	public Long getId() {
		return id;
	}


	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getNetwork() {
		return network;
	}

	public void setNetwork(String network) {
		this.network = network;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getPostedBy() {
		return postedBy;
	}

	public void setPostedBy(String postedBy) {
		this.postedBy = postedBy;
	}

	

	public List<Rate> getRate() {
		return rate;
	}


	public void setRate(List<Rate> rate) {
		this.rate = rate;
	}


	public Show() {
	}



}
