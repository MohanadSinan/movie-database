package com.example.javabelt.controllers;

import java.util.Collections;
import java.util.List;

import javax.servlet.http.HttpSession;
import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.example.javabelt.models.LoginUser;
import com.example.javabelt.models.Rate;
import com.example.javabelt.models.RateRequest;
import com.example.javabelt.models.Show;
import com.example.javabelt.models.User;
import com.example.javabelt.services.RateService;
import com.example.javabelt.services.ShowService;
import com.example.javabelt.services.UserService;



@Controller
public class AppController {
	@Autowired
    private UserService userServ;
	
	@Autowired
    private ShowService showService;
	
	@Autowired
	private RateService rateService;
    // display Registration page
    @GetMapping("/")
    public String index(Model model) {
        model.addAttribute("newUser", new User());
        model.addAttribute("newLogin", new LoginUser());
        return "logReg.jsp";
    }
    
    // process the registration data
    @PostMapping("/register")
    public String register(@Valid @ModelAttribute("newUser") User newUser, 
            BindingResult result,
            Model model,
            RedirectAttributes redirectAttributes
            ) {
    	// send the instance and the result 
        userServ.register(newUser, result);
        if(result.hasErrors()) {
            model.addAttribute("newLogin", new LoginUser());
            return "logReg.jsp";
        }
        redirectAttributes.addFlashAttribute("success", "Your account has been created successfully!");
        return "redirect:/";
    }
    
    // process login data
    @PostMapping("/login")
    public String login(@Valid @ModelAttribute("newLogin") LoginUser newLogin, 
            BindingResult result,
            Model model,
            HttpSession session) {
        User user = userServ.login(newLogin, result);
        if(result.hasErrors()) {
            model.addAttribute("newUser", new User());
            return "logReg.jsp";
        }
        session.setAttribute("userId", user.getId());
        session.setAttribute("userName", user.getName());
        return "redirect:/dashboard";
    }
    
    @GetMapping("/view/{id}")
    public String displayShowDetails(HttpSession session,Model model,
    		@PathVariable("id") Long id,@ModelAttribute("rate") Rate rate,
    		@ModelAttribute("show") Show show) {
    	Show myShow = showService.findById(id);
    	model.addAttribute("myShow",myShow);
    	List<Rate> rates = myShow.getRate();
    	model.addAttribute("rates",rates);
    	return "view.jsp";
    	
    }	
    
    
    @GetMapping("/dashboard")
    public String displayDashboard(HttpSession session,Model model) {
    	if(session.getAttribute("userId") != null) {
         Long idLong = (Long) session.getAttribute("userId");
         String nameString = userServ.findById(idLong).getName();
         model.addAttribute("nameString",nameString);
        //--------------------------------
		List<Show> shows = showService.findAll();
		model.addAttribute("shows", shows);
		
		rateService.getAvg(shows);
        //------------------------------        
    	return "dashboard.jsp";
    }
    	else {
    		return "redirect:/";
    	}
    }
    
    
    
    @GetMapping("/add")
    public String displayaddTemplate(@ModelAttribute("newShow") Show newShow,
    		Model model,HttpSession session) {
    	if(session.getAttribute("userId") != null) {
    	model.addAttribute("newShow",newShow);
    	Long idLong = (Long) session.getAttribute("userId");
    	 String name =(String) session.getAttribute("userName");
    	 model.addAttribute("name",name);
        return "createShow.jsp";
    	}else {
    		
    	}
    	return "redirect:/";
    }
    
    @RequestMapping(value="/addShow", method=RequestMethod.POST)
	public String createEvent(@Valid @ModelAttribute("newShow") Show newShow,
			BindingResult result,
			RedirectAttributes redirectAttributes,
			HttpSession session,
			Model model
			) {
    	 Long idLong = (Long) session.getAttribute("userId");
		 if(result.hasErrors()) {			 
			 return "createShow.jsp";
		 }else {
			 
			 if(showService.findByTitle(newShow.getTitle()) != null) {
				 redirectAttributes.addFlashAttribute("error", "Show title exist !");
				 return "redirect:/add";
			 }
			  Show show = showService.create(newShow);
			  redirectAttributes.addFlashAttribute("success", "Show Created !");
			 return "redirect:/add";
		}
		
	}
    
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.removeAttribute("userId");
        return "redirect:/";
    }
    
    @GetMapping("/edit/{id}")
    public String displayEditTemplate(Model model,
    		@PathVariable("id") Long id,
    		HttpSession session) {
    	if(session.getAttribute("userId") != null) {
        if(!model.containsAttribute("show")) {
        	Show show = showService.findById(id);
        	model.addAttribute("show",show);
        	session.getAttribute("userId");
        }
    	model.addAttribute("showId",id);
        return "edit.jsp";
    }else {
    	return "redirect:/";
    }
    }
    
    @RequestMapping(value="/process/{id}", method=RequestMethod.PUT)
   	public String processEditData(@Valid @ModelAttribute("show") Show show,
   			BindingResult result,
   			Model model,@PathVariable("id") Long id,
   			RedirectAttributes redirectAttributes,HttpSession session
   			) {
   		 if(result.hasErrors()) {
   			 session.getAttribute("userId");
   			 model.addAttribute("show",show);
   			 model.addAttribute("showId",id);
   			 return "edit.jsp";
   		 }else if(showService.findByTitle(show.getTitle()) != null) {
				 redirectAttributes.addFlashAttribute("error", "Show title exist !");
				 return "redirect:/edit/{id}";		 
   		 }else{  			
   			 showService.updateShow(id, show);
			 redirectAttributes.addFlashAttribute("success", "Show Updated !");
   			return "redirect:/edit/{id}";
   		}
   		
   	}
    
    @PostMapping("/rating/{id}")
	public String displaySearchResult(@PathVariable("id") Long id,
			@Valid @ModelAttribute("rateRequest") RateRequest rate,
			BindingResult result,
			RedirectAttributes redirectAttributes,
			HttpSession session,
			Model model
			) {
    	 User user = userServ.findById((Long) session.getAttribute("userId"));
    	 model.addAttribute("id", id);
    	 Show show = showService.findById(id);
    	 model.addAttribute("showId", show.getId());
    	 List<Rate> rates = rateService.getRates(show);
    	 
    	 
    	 
	    	model.addAttribute("rates", rates);
//	    	rate.setId(null);
//	    	System.out.println("ID: "+ rate.getId() +", obj: "+ rate.getRate() +", user: "+ rate.getUser().getName() +", show:"+ rate.getShow().getTitle());
		 if(result.hasErrors()) {			 
			 redirectAttributes.addFlashAttribute("error", "Rate range from 1 to 5 !");
		     return "redirect:/view/"+show.getId();
		 }else{			  
			 model.addAttribute("showId", show.getId());
			 rateService.addRate(show, rate, user);
			 redirectAttributes.addFlashAttribute("success", "show Rated !");
		     return "redirect:/view/"+show.getId();	
	}
        
       
}
    
    @RequestMapping(value="/delete/{id}", method=RequestMethod.DELETE)
    public String destroy(@PathVariable("id") Long id) {
		showService.deleteById(id);
        return "redirect:/dashboard";
    
}
    
    
}
