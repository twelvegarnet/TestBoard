package web.dao;

import java.util.Date;
import java.util.HashMap;
import java.util.List;

import org.apache.poi.xssf.usermodel.XSSFCell;
import org.springframework.stereotype.Repository;
import org.springframework.web.multipart.MultipartFile;

import web.dto.Board;
import web.dto.BoardFile;
import web.dto.Comments;
import web.util.Paging;

@Repository("web.dao.BoardDao")
public interface BoardDao {

	/**
	 * 페이징을 위한 전체 게시물의 수를 얻어온다
	 * @param keyword - 검색어
	 * @param category  - 검색기준
	 * 
	 * @return 전체 게시글의 수
	 */
	int selectCntAll(Paging pagination);

	/**
	 * 게시판 리스트에서 보여주기 위해 전체 게시글의 정보를 얻어온다.
	 * 
	 * @param keyword - 검색어
	 * @param category - 검색 기준
	 * 
	 * @return
	 */
	List<Board> selectAll(Paging paging);

	/**
	 * 게시글 상세보기 페이지에 출력할 데이터를 얻어온다
	 * 
	 * @param board - 게시글 번호가 담겨있는 객체
	 * @return 게시글 번호가 일치하는 전체 데이터
	 */
	Board selectBoardByBoardNo(Board board);

	/**
	 * 글 작성시 첨부한 파일 정보를 DB에 저장한다
	 * 
	 * @param bf - 첨부파일 정보가 담겨있는 객체
	 */
	void insertBoardFiles(BoardFile bf);
	
	/**
	 * 답글 생성시 기존 답글들의 orderNo를 업데이트한다
	 * 
	 * @param board - 직전에 신규 삽입한 게시글 데이터
	 */
	void updateOrderNo(Board board);

	/**
	 * 입력받은 게시글의 제목과 내용을 DB에 저장한다
	 * 
	 * @param board - 제목과 내용을 담고있는 객체
	 */
	void writeBoard(Board board);

	/**
	 * 상세보기에서 글 번호로 첨부파일을 전부 가져온다
	 * 
	 * @param board - 게시글 번호가 담겨있는 객체
	 * @return 게시글 번호에 해당하는 모든 첨부파일 정보
	 */
	List<BoardFile> selectFilesByBoardNo(Board board);

	/**
	 * boardNo가 일치하는 모든 댓글 리스트를 가져온다
	 * 
	 * @param board - 게시글 번호가 담겨있는 객체
	 * @return 해당 게시글 번호와 일치하는 모든 댓글 리스트
	 */
	List<Comments> selectAllCmt(Board board);
	
	/**
	 * 입력받은 정보로 새 댓글을 삽입한다
	 * 
	 * @param comments - 삽입할 신규 댓글의 정보를 담고있는 객체
	 */
	void insertCmt(Comments comments);

	/**
	 * 
	 * 
	 * @param boardFile
	 * @return
	 */
	BoardFile selectByFileno(BoardFile boardFile);
	
	/**
	 * 게시글 번호를 이용해서 해당 게시글의 전체 댓글 리스트를 얻어온다
	 * 
	 * @param comments - 게시글 번호가 담겨있는 객체
	 * @return 해당 게시글 번호 내의 모든 댓글 리스트
	 */
	List<Comments> selectAllCmtAfterInsert(Comments comments);

	/**
	 * 
	 * 
	 * @param comments
	 * @return
	 */
	List<Comments> selectAllCmtList(Comments comments);

	/**
	 * 
	 * 
	 * @param comments
	 */
	void updateCmt(Comments comments);
	
	/**
	 * 수정된 게시글 정보를 DB에 덮어씌운다
	 * 
	 * @param board - 수정된 글 번호, 제목, 내용을 담고있는 객체
	 */
	void updateBoard(Board board);

	/**
	 * 
	 * 
	 * @param comments
	 */
	void deleteCmt(Comments comments);
	
	/**
	 * 
	 * 
	 * @param board
	 * @return
	 */
	int countReply(Board board);
	
	/**
	 * 해당 게시글의 모든 댓글을 삭제한다
	 * 
	 * @param board - 삭제할 게시글 번호를 담고있는 객체
	 */
	void deleteCmts(Board board);
	
	/**
	 * 게시글 수정시 신규추가된 첨부파일이 있다면 기존의 첨부파일을 삭제한다
	 * 
	 * @param board - 삭제할 게시글 번호를 담고있는 객체
	 */
	void deleteFiles(Board board);

	/**
	 * 게시글 번호가 일치하는 게시글을 삭제한다
	 * 
	 * @param board - 게시글 번호를 담고있는 객체
	 */
	void deleteBoard(Board board);

	/**
	 * 게시글 삭제시 하위 답글이 있다면 delete_status를 'Y'로 변경한다
	 * 
	 * @param board - 게시글 번호가 담겨있는 객체
	 */
	void updateBoardForDelete(Board board);

	/**
	 * 게시글을 조회하면 조회수가 1 증가한다
	 * 
	 * @param board - 게시글 번호가 담겨있는 객체
	 */
	void updateHit(Board board);

	/**
	 * 엑셀파일로 보여주기위한 정보만을 가진 전체 게시글 리스트를 얻어온다
	 * 
	 * @return 전체 게시글 리스트
	 */
	List<Board> selectAllForExcel();

	List<Board> selectAllversion2(Paging paging);

	/**
	 * 게시글 수정 시 기존의 첨부파일을 삭제했다면 DB에서 삭제한다
	 * 
	 * @param bfNo - 삭제할 첨부파일 번호
	 */
	void deleteOldFile(int bfNo);

	


	
}
