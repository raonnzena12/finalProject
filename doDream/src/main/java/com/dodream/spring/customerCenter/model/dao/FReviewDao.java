package com.dodream.spring.customerCenter.model.dao;

import java.util.ArrayList;

import org.apache.ibatis.session.RowBounds;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.dodream.spring.common.model.vo.PageInfo;
import com.dodream.spring.customerCenter.model.vo.Review;
import com.dodream.spring.project.model.vo.Project;

@Repository("FReviewDao")
public class FReviewDao {

	@Autowired
	private SqlSessionTemplate sqlSession;

	/**
	 * 프로젝트 후기 리스트를 받아오는 dao
	 * @param category
	 * @return frList
	 */
	public ArrayList<Review> selectList(PageInfo pi) {
		
		// 페이징 처리가 적용된 목록 조회
				// -> Mybatis RowBounds 사용
				
				// offset : 몇 개의 게시글을 건너 뛰고 조회를 할건지에 대한 계산
				int offset = (pi.getCurrentPage() - 1) * pi.getLimit();
		
		// RowBounds는 ibatis의 속성이며, ibatis는 mybatis의 이전 버전이다.
		RowBounds rowBounds = new RowBounds(offset, pi.getLimit());
		System.out.println("여긴 dao로 db 가기전 테스트");
		return (ArrayList) sqlSession.selectList("centerMapper.selectfrList", null, rowBounds);
	}

	/**
	 * 전체 게시물수 조회 DAO
	 * 
	 * @return listCount
	 */
	public int getListCount() {

		return sqlSession.selectOne("centerMapper.getListCount");

	}
	
	/** 후기 조회수 증가 DAO
	 * @param bId
	 */
	public void addReadCount(int revNo) {
		sqlSession.update("centerMapper.updateCount", revNo);
		
	}

	public Review selectReview(int revNo) {
		
		return sqlSession.selectOne(
				"centerMapper.selectRevDetail", revNo);
	}

	public ArrayList<Project> selectPrjList(String category, PageInfo pi) {

		// 페이징 처리가 적용된 목록 조회
		// -> MyBatis RowBounds 사용
		
		// offset : 몇개의 게시글을 건너 뛰고 조회를 할 건지에 대한 계산
		int offset = ( pi.getCurrentPage() - 1 ) * pi.getLimit();
		RowBounds rowBounds = new RowBounds(offset, pi.getLimit());
		
		return (ArrayList)sqlSession.selectList("centerMapper.selectrevList", category, rowBounds);
	}

		/* 
		int offset = ( pi.getCurrentPage() - 1 ) * pi.getLimit();
		RowBounds rowBounds = new RowBounds(offset, pi.getLimit());
		*/
		System.out.println("dao 전달");
		return (ArrayList)sqlSession.selectList("centerMapper.selectfrList", category);
	}


	/** 후기 상세페이지 DAO
	 * @param revId
	 * @return Review
	 */
	public Review selectReview(int revId) {
		
		return sqlSession.selectOne("boardMapper.selectReview", revId);
	}


	/** 후기 조회수증가 DAO
	 * @param revId
	 */
	public void addReadCount(int revId) {
		
		sqlSession.update("centerMapper.updateCount", revId);
	}
}