package com.project.capstone.content.domain;

import com.fasterxml.jackson.annotation.JsonCreator;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.extern.slf4j.Slf4j;

@AllArgsConstructor
@Getter
@Slf4j
public enum ContentType {

    Review("독후감"),
    Quotation("인용구"),
    ShortReview("한줄평");

    private final String type;

    @JsonCreator(mode = JsonCreator.Mode.DELEGATING)
    public static ContentType from(String type) {
        for (ContentType contentType : ContentType.values()) {
            if (contentType.getType().equals(type)) {
                return contentType;
            }
        }
        throw new RuntimeException("잘못된 컨텐츠 타입 입니다.");
    }
}
