package web.dto;

import java.util.Date;

public class Comments {
	private int cNo;
	private int boardNo;
	private String cNick;
	private String cPw;
	private String cComment;
	private Date cCreateDate;
	@Override
	public String toString() {
		return "Comment [cNo=" + cNo + ", boardNo=" + boardNo + ", cNick=" + cNick + ", cPw=" + cPw + ", cComment="
				+ cComment + ", cCreateDate=" + cCreateDate + "]";
	}
	public int getcNo() {
		return cNo;
	}
	public void setcNo(int cNo) {
		this.cNo = cNo;
	}
	public int getBoardNo() {
		return boardNo;
	}
	public void setBoardNo(int boardNo) {
		this.boardNo = boardNo;
	}
	public String getcNick() {
		return cNick;
	}
	public void setcNick(String cNick) {
		this.cNick = cNick;
	}
	public String getcPw() {
		return cPw;
	}
	public void setcPw(String cPw) {
		this.cPw = cPw;
	}
	public String getcComment() {
		return cComment;
	}
	public void setcComment(String cComment) {
		this.cComment = cComment;
	}
	public Date getcCreateDate() {
		return cCreateDate;
	}
	public void setcCreateDate(Date cCreateDate) {
		this.cCreateDate = cCreateDate;
	}
	
	
}
