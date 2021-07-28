package web.service;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;

import javax.servlet.ServletContext;

import org.apache.poi.openxml4j.opc.OPCPackage;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.xssf.streaming.SXSSFSheet;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import web.dao.BoardDao;
import web.dto.Board;
import web.dto.BoardFile;
import web.dto.Comments;
import web.util.Paging;


@Service("web.service.BoardService")
public class BoardServiceImpl implements BoardService{
	private static final Logger logger = LoggerFactory.getLogger(BoardServiceImpl.class);
	
	@Autowired
	BoardDao boardDao;
	
	@Autowired
	ServletContext context;
	
	@Override
	public Paging getPaging(Paging pagination) {
		int curPage = pagination.getCurPage();
		int totalCount = boardDao.selectCntAll(pagination);
		int listCount = pagination.getListCount();
		Paging paging = new Paging(totalCount, curPage, listCount);
		
		return paging;
	}
	
	@Override
	public List<Board> getList(Paging paging) {
		//모든 게시글이 순서대로 해서 총 게시글을 알 수 있는 방식
//		return boardDao.selectAll(paging);
		
		//전체 게시판에서는 원글만 글번호가 나타나서 원글의 전체 수를 알 수 있고
		//검색 후 게시판에서는 원글과 답글 글번호가 모두 나타나 총 게시글의 수를 알 수 있다
		return boardDao.selectAllversion2(paging);
	}

	@Override
	@Transactional
	public Board getBoard(Board board) {
		boardDao.updateHit(board);
		Board viewBoard = boardDao.selectBoardByBoardNo(board);
		
		return viewBoard;
	}
	
	@Override
	public List<BoardFile> getFiles(Board board) {
		return boardDao.selectFilesByBoardNo(board);
	}
	

	@Override
	public List<Comments> getCmtList(Board board) {
		return boardDao.selectAllCmt(board);
	}

	@Override
	public BoardFile getFileForDown(BoardFile boardFile) {
		return boardDao.selectByFileno(boardFile);
	}

	@Override
	@Transactional
	public List<Comments> writeCmt(Comments comments) {
		boardDao.insertCmt(comments);
		return boardDao.selectAllCmtAfterInsert(comments);
	}
	
	@Override
	public List<Comments> getCmtListAll(Comments comments) {
		return boardDao.selectAllCmtList(comments);
	}
	
	@Override
	public void updateCmt(Comments comments) {
		boardDao.updateCmt(comments);
	}
	
	@Override
	public void deleteCmt(Comments comments) {
		boardDao.deleteCmt(comments);
	}
	
	@Override
	@Transactional
	public void write(Board board, List<MultipartFile> fileList) {
		logger.info("write 직전 board의 값 : {}", board);
		if(board.getParentNo() != 0) {
			boardDao.updateOrderNo(board);
		}
		boardDao.writeBoard(board);
		
		String storedPath = context.getRealPath("resources");
		
		File stored = new File(storedPath);
		if( !stored.exists() ) {
			stored.mkdir();
		}
		
		for( MultipartFile file : fileList ) {
			
			if( file.getSize() <= 0 ) {
				return;
			}
			
 			String filename = file.getOriginalFilename();
			String uid = UUID.randomUUID().toString().split("-")[4];
			filename += uid;
			File dest = new File( stored, filename );
				
			try {
				file.transferTo(dest);
			} catch (IllegalStateException e) {
				e.printStackTrace();
			} catch (IOException e) {
				e.printStackTrace();
			}
			
			BoardFile bf = new BoardFile();
			bf.setBoardNo(board.getBoardNo());
			bf.setBfOriginName(file.getOriginalFilename());
			bf.setBfStoredName( filename );
			bf.setBfSize((int) file.getSize());
			bf.setBfContentType(file.getContentType());
			
			boardDao.insertBoardFiles( bf );
		} // for문 end
	}
	

	@Override
	public void deleteOldFile(String[] oldFile) {
		for(String f : oldFile) {
			int bfNo = Integer.parseInt(f);
//			logger.info("삭제해야할 파일번호 : {}", bfNo);
			boardDao.deleteOldFile(bfNo);
		}
	}

	@Override
	@Transactional
	public void update(Board board, List<MultipartFile> fileList) {
		//글 내용 수정
		boardDao.updateBoard(board);
		
		//첨부파일 수정 ( 삭제 및 신규 등록 )
		String storedPath = context.getRealPath("resources");
		
		File stored = new File(storedPath);
		if( !stored.exists() ) {
			stored.mkdir();
		}
		
		//수정된 첨부파일이 있을 경우 기존의 첨부파일을 삭제한다
//		for( MultipartFile file : fileList ) {
//			if( file.getSize() <= 0 ) {
//				return;
//			} else {
//				boardDao.deleteFiles(board);
//				break;
//			}
//		}
		
		//수정된 첨부파일이 있을 경우 신규 첨부파일을 삽입한다
		for( MultipartFile file : fileList ) {
			
			if( file.getSize() <= 0 ) {
				return;
			}
			
			String filename = file.getOriginalFilename();
			String uid = UUID.randomUUID().toString().split("-")[4];
			filename += uid;
			File dest = new File( stored, filename );
				
			try {
				file.transferTo(dest);
			} catch (IllegalStateException e) {
				e.printStackTrace();
			} catch (IOException e) {
				e.printStackTrace();
			}
			
			BoardFile bf = new BoardFile();
			bf.setBoardNo(board.getBoardNo());
			bf.setBfOriginName(file.getOriginalFilename());
			bf.setBfStoredName( filename );
			bf.setBfSize((int) file.getSize());
			bf.setBfContentType(file.getContentType());
			
			logger.info("삽입해야하는 파일 이름 : {}", file.getOriginalFilename());
			
			boardDao.insertBoardFiles( bf );
			
		} // for문 end
	}

	@Override
	@Transactional
	public void deleteBoard(Board board) {
		int res = boardDao.countReply(board);
		
		if(res == 0) {
			boardDao.deleteCmts(board);
			boardDao.deleteFiles(board);
			boardDao.deleteBoard(board);
		} else {
			boardDao.updateBoardForDelete(board);
		}
		
	}

	@Override
	public List<Board> getBoardList() {
		return boardDao.selectAllForExcel();
	}

	public SXSSFWorkbook makeSimpleBoardExcelWorkbook(List<Board> blist) {
		SXSSFWorkbook workbook = new SXSSFWorkbook();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        
        // 시트 생성
        SXSSFSheet sheet = workbook.createSheet("게시글 리스트");
        
        //시트 열 너비 설정
        sheet.setColumnWidth(0, 3000);
        sheet.setColumnWidth(1, 3000);
        sheet.setColumnWidth(2, 10500);
        sheet.setColumnWidth(3, 24000);
        sheet.setColumnWidth(4, 6000);
        sheet.setColumnWidth(5, 3000);
        sheet.setColumnWidth(6, 1500);
        
        // 헤더 행 생
        Row headerRow = sheet.createRow(0);
        // 해당 행의 첫번째 열 셀 생성
        Cell headerCell = headerRow.createCell(0);
        headerCell.setCellValue("");
        // 해당 행의 두번째 열 셀 생성
        headerCell = headerRow.createCell(1);
        headerCell.setCellValue("글번호");
        // 해당 행의 세번째 열 셀 생성
        headerCell = headerRow.createCell(2);
        headerCell.setCellValue("게시글 제목");
        // 해당 행의 네번째 열 셀 생성
        headerCell = headerRow.createCell(3);
        headerCell.setCellValue("게시글 내용");
        // 해당 행의 다섯번째 열 셀 생성
        headerCell = headerRow.createCell(4);
        headerCell.setCellValue("작성자");
        // 해당 행의 여섯번째 열 셀 생성
        headerCell = headerRow.createCell(5);
        headerCell.setCellValue("작성일");
        // 해당 행의 일곱번째 열 셀 생성
        headerCell = headerRow.createCell(6);
        headerCell.setCellValue("조회수");
        
        // 게시글 리스트 내용 행 및 셀 생성
        Row bodyRow = null;
        Cell bodyCell = null;
        for(int i=0; i<blist.size(); i++) {
            Board board = blist.get(i);
            
            // 행 생성
            bodyRow = sheet.createRow(i+1);
            // 데이터 번호 표시
            bodyCell = bodyRow.createCell(0);
            bodyCell.setCellValue("");
            // 글 번호 표시
            bodyCell = bodyRow.createCell(1);
            bodyCell.setCellValue(board.getRownum());
            // 글 제목 표시
            bodyCell = bodyRow.createCell(2);
            bodyCell.setCellValue(board.getBoardTitle());
            // 글 내용 표시
            bodyCell = bodyRow.createCell(3);
            bodyCell.setCellValue(board.getBoardContent());
            // 작성자 표시
            bodyCell = bodyRow.createCell(4);
            bodyCell.setCellValue(board.getBoardNick());
            // 작성일 표시
            bodyCell = bodyRow.createCell(5);
            bodyCell.setCellValue(sdf.format(board.getCreateDate()));
            // 조회수 표시
            bodyCell = bodyRow.createCell(6);
            bodyCell.setCellValue(board.getHit());
        }
        
        return workbook;
	}

	@Override
	public SXSSFWorkbook excelFileDownloadProcess(List<Board> blist) {
		return this.makeSimpleBoardExcelWorkbook(blist);
	}

	@Override
	@Transactional
	public void uploadExcelFile(MultipartFile file) {
		List<Board> blist = new ArrayList<Board>();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		
        try {
            OPCPackage opcPackage = OPCPackage.open(file.getInputStream());
            XSSFWorkbook workbook = new XSSFWorkbook(opcPackage);
            
            // 첫번째 시트 불러오기
            XSSFSheet sheet = workbook.getSheetAt(0);
            
            for(int i=1; i<sheet.getLastRowNum() + 1; i++) {
                Board board = new Board();
                XSSFRow row = sheet.getRow(i);
                
                // 행이 존재하기 않으면 패스
                if(null == row) {
                    continue;
                }
                
                // 행의 두번째 열(이름부터 받아오기) 
                XSSFCell cell = row.getCell(0);
                if(null != cell) board.setBoardNick(cell.getStringCellValue());
                // 행의 세번째 열 받아오기
                cell = row.getCell(1);
                if(null != cell) board.setBoardPw(cell.getStringCellValue());
                // 행의 네번째 열 받아오기
                cell = row.getCell(2);
                if(null != cell) board.setBoardTitle(cell.getStringCellValue());
                // 행의 네번째 열 받아오기
                cell = row.getCell(3);
                if(null != cell) board.setBoardContent(cell.getStringCellValue());
                // 행의 네번째 열 받아오기
                cell = row.getCell(4);
                if(null != cell) board.setCreateDate(cell.getDateCellValue());
                
//                blist.add(board);
                
                logger.info("얻어온 board DATA 하나씩 확인 : {}", board);
                boardDao.writeBoard(board);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
	}

	
}
