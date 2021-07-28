package web.dto;

import java.util.Date;

public class Board {
	private int boardNo;
	private String boardNick;
	private String boardPw;
	private String boardTitle;
	private String boardContent;
	private Date createDate;
	private int hit;
	private int recommend;
	private int rnum;
	private int rownum;
	private int layerNo;
	private int groupNo;
	private int orderNo;
	private int parentNo;
	private int countCmt;
	private int countFile;
	private String deleteStatus;
	@Override
	public String toString() {
		return "Board [boardNo=" + boardNo + ", boardNick=" + boardNick + ", boardPw=" + boardPw + ", boardTitle="
				+ boardTitle + ", boardContent=" + boardContent + ", createDate=" + createDate + ", hit=" + hit
				+ ", recommend=" + recommend + ", rnum=" + rnum + ", rownum=" + rownum + ", layerNo=" + layerNo
				+ ", groupNo=" + groupNo + ", orderNo=" + orderNo + ", parentNo=" + parentNo + ", countCmt=" + countCmt
				+ ", countFile=" + countFile + ", deleteStatus=" + deleteStatus + "]";
	}
	public int getBoardNo() {
		return boardNo;
	}
	public void setBoardNo(int boardNo) {
		this.boardNo = boardNo;
	}
	public String getBoardNick() {
		return boardNick;
	}
	public void setBoardNick(String boardNick) {
		this.boardNick = boardNick;
	}
	public String getBoardPw() {
		return boardPw;
	}
	public void setBoardPw(String boardPw) {
		this.boardPw = boardPw;
	}
	public String getBoardTitle() {
		return boardTitle;
	}
	public void setBoardTitle(String boardTitle) {
		this.boardTitle = boardTitle;
	}
	public String getBoardContent() {
		return boardContent;
	}
	public void setBoardContent(String boardContent) {
		this.boardContent = boardContent;
	}
	public Date getCreateDate() {
		return createDate;
	}
	public void setCreateDate(Date createDate) {
		this.createDate = createDate;
	}
	public int getHit() {
		return hit;
	}
	public void setHit(int hit) {
		this.hit = hit;
	}
	public int getRecommend() {
		return recommend;
	}
	public void setRecommend(int recommend) {
		this.recommend = recommend;
	}
	public int getRnum() {
		return rnum;
	}
	public void setRnum(int rnum) {
		this.rnum = rnum;
	}
	public int getRownum() {
		return rownum;
	}
	public void setRownum(int rownum) {
		this.rownum = rownum;
	}
	public int getLayerNo() {
		return layerNo;
	}
	public void setLayerNo(int layerNo) {
		this.layerNo = layerNo;
	}
	public int getGroupNo() {
		return groupNo;
	}
	public void setGroupNo(int groupNo) {
		this.groupNo = groupNo;
	}
	public int getOrderNo() {
		return orderNo;
	}
	public void setOrderNo(int orderNo) {
		this.orderNo = orderNo;
	}
	public int getParentNo() {
		return parentNo;
	}
	public void setParentNo(int parentNo) {
		this.parentNo = parentNo;
	}
	public int getCountCmt() {
		return countCmt;
	}
	public void setCountCmt(int countCmt) {
		this.countCmt = countCmt;
	}
	public int getCountFile() {
		return countFile;
	}
	public void setCountFile(int countFile) {
		this.countFile = countFile;
	}
	public String getDeleteStatus() {
		return deleteStatus;
	}
	public void setDeleteStatus(String deleteStatus) {
		this.deleteStatus = deleteStatus;
	}
	
	
	
}
