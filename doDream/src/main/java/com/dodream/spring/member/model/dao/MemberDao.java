package com.dodream.spring.member.model.dao;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.dodream.spring.member.model.vo.Member;

@Repository("mDao")
public class MemberDao {

	@Autowired
	private SqlSessionTemplate sqlSession;

	public Member selectMember(Member mem) {
		return sqlSession.selectOne("memberMapper.selectOne", mem);
	}

	public List<Member> selectCheckEmail(String userEmail) {
		return sqlSession.selectList("memberMapper.selectCheckEmail", userEmail);
	}

	public List<Member> selectCheckNickname(String userNickname) {
		return sqlSession.selectList("memberMapper.selectCheckNickname", userNickname);
	}

	public int insertMember(Member member) {
		return sqlSession.insert("memberMapper.insertMember", member);
  }
  
  public int countVisitToday(int userNo) {
		return sqlSession.insert("memberMapper.countVisitToday",userNo);
	}

	public int checkVisitToday(int userNo) {
		return sqlSession.selectOne("memberMapper.checkVisitToday",userNo);
	}
}
