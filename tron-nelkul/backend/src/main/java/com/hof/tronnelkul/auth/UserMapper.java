package com.hof.tronnelkul.auth;

import com.hof.tronnelkul.api.model.UserDto;
import com.hof.tronnelkul.user.AppUser;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingConstants;
import org.mapstruct.ReportingPolicy;

@Mapper(componentModel = MappingConstants.ComponentModel.SPRING, unmappedTargetPolicy = ReportingPolicy.ERROR)
public interface UserMapper {
    @Mapping(target = "name", source = "displayName")
    UserDto dto(AppUser user);
}
