package web.controller;

import java.util.Iterator;
import java.util.List;
import java.util.Locale;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;

import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import web.dto.Board;
import web.dto.BoardFile;
import web.dto.Comments;
import web.service.BoardService;
import web.util.Paging;

@Controller("web.controller.BoardController")
@RequestMapping(value="/board")
public class BoardController {
	private static final Logger logger = LoggerFactory.getLogger(BoardController.class);
	
	@Autowired
	BoardService boardService;
	
	@Autowired 
	ServletContext servletContext;
	
	@RequestMapping(value="/list")
	public void list(
			@RequestParam(defaultValue="0") int curPage
			, @RequestParam(defaultValue="") String category
			, @RequestParam(defaultValue="") String search
			, @RequestParam(defaultValue="0") int listCount
			, Model model
			) {
//		logger.info("/board/list [GET] 요청 완료");
		Paging pagination = new Paging();
		pagination.setCurPage(curPage);
		pagination.setCategory(category);
		pagination.setSearch(search);
		pagination.setListCount(listCount);
		
		Paging paging = boardService.getPaging(pagination);
		paging.setCategory(category);
		paging.setSearch(search);
		model.addAttribute("paging", paging);
		
		//전체 게시글 리스트 얻어오기
		List<Board> blist = boardService.getList(paging);
		model.addAttribute("blist", blist);
		
		int newListCount = paging.getListCount();
		model.addAttribute("listCount", newListCount);
	}
	
	@RequestMapping(value="/view")
	public void view(Board board, Model model) {
//		logger.info("얻어온 boardNo 확인 : {}",board);
		
		//글 번호로 게시글 전체 데이터 얻어오기
		Board viewBoard = boardService.getBoard(board);
		model.addAttribute("board", viewBoard);
		
		//글 번호로 게시글 첨부파일 얻어오기
		List<BoardFile> flist = boardService.getFiles(board);
//		logger.info("얻어온 첨부파일 데이터 확인 : {}", flist);
		model.addAttribute("file", flist);
		
		List<Comments> clist = boardService.getCmtList(board);
		model.addAttribute("clist", clist);
	}
	
	@RequestMapping(value="/download")
	public String down(BoardFile boardFile, Model model) {
		BoardFile bf = boardService.getFileForDown(boardFile);
		model.addAttribute("downFile", bf);
		return "down";
	}
	
	@RequestMapping(value="/comments/insert", method=RequestMethod.GET)
	public String comments(Comments comments, Model model) {
//		logger.info("얻어온 comment 데이터 확인 : {}", comment);
		List<Comments> clist = boardService.writeCmt(comments);
		model.addAttribute("clist", clist);
		return "board/comments";
	}
	
	@RequestMapping(value="/comments/update", method=RequestMethod.GET)
	public String commentsUpdateForm(Comments comments, Model model) {
		List<Comments> clist = boardService.getCmtListAll(comments);
		model.addAttribute("clist", clist);
		model.addAttribute("standard", comments.getcNo());
		return "board/comments";
	}
	
	@RequestMapping(value="/comments/update", method=RequestMethod.POST)
	public String commentUpdate(Comments comments, Model model) {
		boardService.updateCmt(comments);
		List<Comments> clist = boardService.getCmtListAll(comments);
		model.addAttribute("clist", clist);
		return "board/comments";
	}
	
	@RequestMapping(value="/comments/updateCancel", method=RequestMethod.GET)
	public String commentsUpdateCancel(Comments comments, Model model) {
		List<Comments> clist = boardService.getCmtListAll(comments);
		model.addAttribute("clist", clist);
		return "board/comments";
	}
	
	@RequestMapping(value="/comments/delete", method=RequestMethod.GET)
	public String commentsDelete(Comments comments, Model model) {
		boardService.deleteCmt(comments);
		List<Comments> clist = boardService.getCmtListAll(comments);
		model.addAttribute("clist", clist);
		return "board/comments";
	}
	
	@RequestMapping(value="/write", method=RequestMethod.GET)
	public String writeForm(Board board, Model model) {
//		logger.info("/board/write [GET] 요청 완료");
		logger.info("writeForm [GET] board 데이터 확인 : {}", board);
		model.addAttribute("board", board);
		
		return "board/write2";
	}
	
	@RequestMapping(value="/write", method=RequestMethod.POST)
	public String write(Board board, MultipartHttpServletRequest mtfRequest) {
//		logger.info("write [POST] board 데이터 확인 : {}", board);
		List<MultipartFile> fileList = mtfRequest.getFiles("file");
		logger.info("작성시 첨부한 점부파일 데이터 확인 : {}", fileList);
//		boardService.write(board, fileList);
		
		return "redirect:/board/list";
	}
	
	
	@RequestMapping(value="/update", method=RequestMethod.GET)
	public String updateForm(Board board, Model model) {
		Board b = boardService.getBoard(board);
		List<BoardFile> flist = boardService.getFiles(board);

		model.addAttribute("board", b);
		model.addAttribute("file", flist);
		
		return "board/update2";
	}
	
	@RequestMapping(value="/update", method=RequestMethod.POST)
	@Transactional
	public String update(Board board, HttpServletRequest request, MultipartHttpServletRequest mtfRequest) {
//		logger.info("update용 데이터 확인 : {}", board);
		
		String[] oldFile = request.getParameterValues("oldFile");
		if(oldFile != null) {
//			for( String s : oldFile) {
//				logger.info("얻어온 삭제 파일번호 리스트 확인 : {}", s);
//			}
			boardService.deleteOldFile(oldFile);
		}
		
		List<MultipartFile> fileList = mtfRequest.getFiles("file");
		logger.info("update용 신규 첨부파일 확인 : {}", fileList);
		
		//글 내용과 첨부파일을 update한다
		boardService.update(board, fileList);
		
		return "redirect:/board/view?boardNo="+board.getBoardNo();
	}
	
	@RequestMapping(value="/delete")
	public String delete(Board board) {
		boardService.deleteBoard(board);
		return "redirect:/board/list";
	}
	
	@RequestMapping(value="/downloadExcelFile", method=RequestMethod.POST)
	public String downloadExcelFile(Model model) {
		List<Board> blist = boardService.getBoardList();
        
        SXSSFWorkbook workbook = boardService.excelFileDownloadProcess(blist);
        
        model.addAttribute("locale", Locale.KOREA);
        model.addAttribute("workbook", workbook);
        model.addAttribute("workbookName", "게시판");
        
        return "excelDownloadView";
	}
	
	
	@RequestMapping(value = "/uploadExcelFile", method = RequestMethod.POST)
	@Transactional
    public String uploadExcelFile(MultipartHttpServletRequest request, Model model) {
        MultipartFile file = null;
        Iterator<String> iterator = request.getFileNames();
        if(iterator.hasNext()) {
            file = request.getFile(iterator.next());
        }
        
//        logger.info("얻어온 file 데이터 확인 : {}", file.getContentType());
        
        String correctContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
        
        if(correctContentType.equals(file.getContentType())) {
//        	logger.info("올바른 타입입니다.");
	        boardService.uploadExcelFile(file);
	        return "board/list";
        } else {
//        	logger.info("잘못된 형식의 파일입니다. Excel 파일을 첨부해주세요.");
        	return null;
        }
        
	}

	
}
