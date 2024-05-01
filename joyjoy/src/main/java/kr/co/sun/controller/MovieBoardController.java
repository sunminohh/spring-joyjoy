package kr.co.sun.controller;

import java.nio.file.Files;


import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import kr.co.sun.domain.MovieAttachVO;
import kr.co.sun.domain.MovieBoardVO;
import kr.co.sun.domain.Pagination;
import kr.co.sun.dto.PageDTO;
import kr.co.sun.service.MovieBoardService;
import lombok.AllArgsConstructor;
import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Controller
@Log4j
@RequestMapping("/movie/*")
@AllArgsConstructor
public class MovieBoardController {

	private MovieBoardService service;
	
	@GetMapping("/list")
	public void list(Pagination page, Model model) {
		
		log.info("list: " + page);
		model.addAttribute("list", service.getList(page));
		
		int total = service.getTotal(page);
		
		log.info("total: " + total);
		model.addAttribute("pageMaker", new PageDTO(page, total));
	}
	
	@GetMapping("/register")
	@PreAuthorize("isAuthenticated()")
	public void register() {
		
	}
	
	@PreAuthorize("isAuthenticated()")
	@PostMapping("/register")
	public String register(MovieBoardVO board, RedirectAttributes rttr) {
		
		log.info("register: " + board);
		
		if (board.getAttachList() != null) {
			
			board.getAttachList().forEach(attach -> log.info(attach));
		}
		
		service.register(board);
		rttr.addFlashAttribute("result", board.getBno());
		
		return "redirect:/movie/list";
	}
	
	
	@GetMapping("/detail")
	public void get(@RequestParam("bno") Long bno, 
			@ModelAttribute("page") Pagination page, Model model) {
		
		log.info("detail: " + bno);
		
		service.updateRead(bno);
		model.addAttribute("board", service.get(bno));
	}
	
	@GetMapping("/modify")
	public void modify(@RequestParam("bno") Long bno, 
			@ModelAttribute("page") Pagination page, Model model) {
		
		log.info("modify: " + bno);
		model.addAttribute("board", service.get(bno));
	}
	
	@PreAuthorize("principal.username == #board.writer")
	@PostMapping("/modify")
	public String moddify(MovieBoardVO board, 
			@ModelAttribute("page") Pagination page,
			RedirectAttributes rttr) {
		log.info("modify: " + board);
		
		if(service.modify(board)) {
			rttr.addFlashAttribute("result", "success");
		}
	
		return "redirect:/movie/list" + page.getListLink();
	}
	
	@PreAuthorize("principal.username == #writer")
	@PostMapping("/remove")
	public String remove(@RequestParam("bno") Long bno,
			@ModelAttribute("page") Pagination page,
			RedirectAttributes rttr, String writer) {
		
		log.info("remove: " + bno);
		
		List<MovieAttachVO> attachList = service.getAttachList(bno);
		
		if (service.remove(bno)) {
			// delete Attach Files
			deleteFiles(attachList);
			
			rttr.addFlashAttribute("result", "success");
		}
		
		return "redirect:/movie/list" + page.getListLink();
	}
	
	@GetMapping(value = "/getAttachList", 
				produces = MediaType.APPLICATION_JSON_UTF8_VALUE)
	@ResponseBody
	public ResponseEntity<List<MovieAttachVO>> getAttachList(Long bno){
		
		log.info("getAttachList " + bno);
		
		return new ResponseEntity<>(service.getAttachList(bno), HttpStatus.OK);
	}
	
	private void deleteFiles(List<MovieAttachVO> attachList) {
		
		if (attachList == null || attachList.size() == 0) {
			return;
		}
		
		log.info("delete attach files......................");
		log.info(attachList);
		
		attachList.forEach(attach -> {
			try {
				Path file = Paths.get("C:\\upload\\movie\\" 
			+ attach.getUploadPath() + "\\" + attach.getUuid()
			+ "_" + attach.getFileName());
				
				Files.deleteIfExists(file);
				
				if (Files.probeContentType(file).startsWith("image")) {
					
					Path thumbNail = Paths.get("C:\\upload\\movie\\" 
					+ attach.getUploadPath() + "\\s_" + attach.getUuid()
					+ "_" + attach.getFileName());
					
					Files.delete(thumbNail);
				}
				
			} catch (Exception e) {
				log.error("delete file error" + e.getMessage());
			} // end catch
		}); // end forEach
	}
	
	
}










