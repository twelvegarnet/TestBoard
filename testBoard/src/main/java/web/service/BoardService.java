package web.service;

import java.util.List;

import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.springframework.web.multipart.MultipartFile;

import web.dto.Board;
import web.dto.BoardFile;
import web.dto.Comments;
import web.util.Paging;

public interface BoardService {
	
	/**
	 * 페이지네이션을 위한 값을 얻어온다
	 * @param keyword - 검색어
	 * @param category - 검색기준
	 * 
	 * @return 해당 페이지의 정보를 가진 paging 객체
	 */
	public Paging getPaging(Paging pagination);

	/**
	 * 게시판 전체 리스트를 얻어온다
	 * 
	 * @param keyword - 검색어
	 * @param category  - 검색기준
	 * 
	 * @return 전체 게시글 리스트
	 */
	public List<Board> getList(Paging paging);

	/**
	 * 게시글 상세보기 페이지에 출력할 데이터를 얻어온다
	 * 
	 * @param board - 게시글 번호가 담겨있는 객체
	 * @return 게시글 번호가 일치하는 전체 데이터
	 */
	public Board getBoard(Board board);

	/**
	 * 상세보기에서 글 번호로 첨부파일을 전부 가져온다
	 * 
	 * @param board - 게시글 번호가 담겨있는 객체
	 * @return 게시글 번호에 해당하는 모든 첨부파일 정보
	 */
	public List<BoardFile> getFiles(Board board);
	
	/**
	 * 게시글 상세보기 페이지에서 보여줄 댓글 리스트를 얻어온다
	 * 
	 * @param board - 게시글 번호가 담겨있는 객체
	 * @return - 해당 게시글 번호를 갖고있는 모든 댓글 리스트
	 */
	public List<Comments> getCmtList(Board board);

	/**
	 * 
	 * 
	 * @param boardFile
	 * @return
	 */
	public BoardFile getFileForDown(BoardFile boardFile);
	
	/**
	 * 신규 댓글을 삽입한다
	 * 
	 * @param comment - 신규 삽입할 댓글 정보를 담고있는 객체
	 * @return 
	 */
	public List<Comments> writeCmt(Comments comments);
	
	/**
	 * 
	 * 
	 * @param comments
	 * @return
	 */
	public List<Comments> getCmtListAll(Comments comments);

	/**
	 * 
	 * 
	 * @param comments
	 */
	public void updateCmt(Comments comments);
	
	/**
	 * 
	 * 
	 * @param comments
	 */
	public void deleteCmt(Comments comments);
	
	/**
	 * 글쓰기 폼에서 입력한 데이터를 DB에 저장한다
	 * 
	 * @param board - 게시글 제목과 내용이 담겨있는 객체
	 * @param fileList - 첨부파일 데이터가 담겨있는 객체
	 */
	public void write(Board board, List<MultipartFile> fileList);

	/**
	 * 게시글 수정 시 기존의 첨부파일을 삭제했다면 해당 첨부파일을 삭제한다
	 * 
	 * @param oldFile - 삭제할 기존 첨부파일 번호를 가진 배열
	 */
	public void deleteOldFile(String[] oldFile);

	/**
	 * 게시글 수정 데이터를 기존 글번호 DB에 덮어씌운다
	 * 
	 * @param board - 수정된 글 번호, 제목, 내용이 담겨있는 객체
	 * @param fileList - 수정된 첨부파일 리스트
	 */
	public void update(Board board, List<MultipartFile> fileList);

	/**
	 * 글 삭제시 첨부파일을 먼저 삭제한다(primary key - foreign key로 연결되어 있음)
	 * 
	 * @param board - 게시글 번호를 담고있는 객체
	 */
	public void deleteBoard(Board board);

	/**
	 * 엑셀파일로 보여주기위한 정보만을 가진 전체 게시글 리스트를 얻어온다
	 * 
	 * @return 전체 게시글 리스트
	 */
	public List<Board> getBoardList();

	/**
	 * 게시글 목록 excelDown을 구현한다
	 * 
	 * @param blist - 전체 게시글 리스트
	 * @return 엑셀을 위한 데이터 처리 완료 객체
	 */
	public SXSSFWorkbook excelFileDownloadProcess(List<Board> blist);

	/**
	 * 업로드된 엑셀파일로 게시글 리스트를 추가한다
	 * 
	 * @param file - 게시글 목록이 담긴 엑셀 파일
	 * @return 
	 * @return 생성한 게시글 리스트
	 */
	public void uploadExcelFile(MultipartFile file);





	
	

}
