package kr.co.sun.domain;

import java.util.Date;

import lombok.Data;

@Data
public class MovieReplyVO {

	private Long rno;
	private Long bno;
	
	private String reply;
	private String replyer;
	private Date replyDate;
	private Date updateDate;
	
}