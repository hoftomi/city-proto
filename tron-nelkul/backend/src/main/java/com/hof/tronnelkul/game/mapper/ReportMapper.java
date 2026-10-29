package com.hof.tronnelkul.game.mapper;

import com.hof.tronnelkul.api.model.ReportView;
import com.hof.tronnelkul.game.model.ReportEntity;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingConstants;
import org.mapstruct.ReportingPolicy;

@Mapper(componentModel = MappingConstants.ComponentModel.SPRING, unmappedTargetPolicy = ReportingPolicy.ERROR)
public interface ReportMapper {
    @Mapping(target = "round", source = "settlement")
    @Mapping(target = "text", source = "body")
    @Mapping(target = "isPublic", source = "public")
    ReportView view(ReportEntity report);
}
