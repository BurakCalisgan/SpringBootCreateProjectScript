package com.example.demo.entity;

import jakarta.persistence.Column;
import jakarta.persistence.MappedSuperclass;
import jakarta.persistence.Version;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.util.Date;

@Getter
@Setter
@MappedSuperclass
public abstract class BaseEntity {

    @Column(name = "status")
    private boolean status;

    @Column(name = "create_user")
    private String createUser;

    @CreationTimestamp
    @Column(name = "create_date")
    private Date createDate;

    @Column(name = "update_user")
    private String updateUser;

    @UpdateTimestamp
    @Column(name = "update_date")
    private Date updateDate;

    @Version
    @Column(name = "update_count")
    private int updateCount;

}
