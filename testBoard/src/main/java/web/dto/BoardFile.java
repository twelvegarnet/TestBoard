package web.dto;

import java.util.Date;

public class BoardFile {
	private int bfNo;
	private int boardNo;
	private String bfOriginName;
	private String bfStoredName;
	private Date bfCreateDate;
	private int bfSize;
	private String bfContentType;
	
	@Override
	public String toString() {
		return "BoardFile [bfNo=" + bfNo + ", boardNo=" + boardNo + ", bfOriginName=" + bfOriginName + ", bfStoredName="
				+ bfStoredName + ", bfCreateDate=" + bfCreateDate + ", bfSize=" + bfSize + ", bfContentType="
				+ bfContentType + "]";
	}
	
	public int getBfNo() {
		return bfNo;
	}
	public void setBfNo(int bfNo) {
		this.bfNo = bfNo;
	}
	public int getBoardNo() {
		return boardNo;
	}
	public void setBoardNo(int boardNo) {
		this.boardNo = boardNo;
	}
	public String getBfOriginName() {
		return bfOriginName;
	}
	public void setBfOriginName(String bfOriginName) {
		this.bfOriginName = bfOriginName;
	}
	public String getBfStoredName() {
		return bfStoredName;
	}
	public void setBfStoredName(String bfStoredName) {
		this.bfStoredName = bfStoredName;
	}
	public Date getBfCreateDate() {
		return bfCreateDate;
	}
	public void setBfCreateDate(Date bfCreateDate) {
		this.bfCreateDate = bfCreateDate;
	}
	public int getBfSize() {
		return bfSize;
	}
	public void setBfSize(int bfSize) {
		this.bfSize = bfSize;
	}
	public String getBfContentType() {
		return bfContentType;
	}
	public void setBfContentType(String bfContentType) {
		this.bfContentType = bfContentType;
	}

	
}
