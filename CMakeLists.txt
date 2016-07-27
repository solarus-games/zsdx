cmake_minimum_required(VERSION 2.6)
project(ZSDX)

set(quest_name "zsdx")

set(SOLARUS_INSTALL_DATAROOTDIR "share" CACHE PATH "dataroot dir")
set(SOLARUS_INSTALL_DATADIR "${SOLARUS_INSTALL_DATAROOTDIR}/solarus" CACHE PATH "data dir")
set(SOLARUS_INSTALL_BINDIR "bin" CACHE PATH "bin dir")

if (IS_ABSOLUTE ${SOLARUS_INSTALL_DATADIR})
  set(SOLARUS_INSTALL_ABSOLUTE_DATADIR ${SOLARUS_INSTALL_DATADIR})
else()
  set(SOLARUS_INSTALL_ABSOLUTE_DATADIR ${CMAKE_INSTALL_PREFIX}/${SOLARUS_INSTALL_DATADIR})
endif()

# data files list
file(GLOB_RECURSE data_files
  RELATIVE ${CMAKE_CURRENT_SOURCE_DIR}/data
  ${CMAKE_CURRENT_SOURCE_DIR}/data/*.spc
  ${CMAKE_CURRENT_SOURCE_DIR}/data/*.ogg
  ${CMAKE_CURRENT_SOURCE_DIR}/data/*.it
  ${CMAKE_CURRENT_SOURCE_DIR}/data/*.png
  ${CMAKE_CURRENT_SOURCE_DIR}/data/*.dat
  ${CMAKE_CURRENT_SOURCE_DIR}/data/*.lua
  ${CMAKE_CURRENT_SOURCE_DIR}/data/*.ttf
  ${CMAKE_CURRENT_SOURCE_DIR}/data/*.ttc
  ${CMAKE_CURRENT_SOURCE_DIR}/data/*.fon
)

file(GLOB_RECURSE data_files_prefixed
  RELATIVE ${CMAKE_CURRENT_SOURCE_DIR}
  ${CMAKE_CURRENT_SOURCE_DIR}/data/*.spc
  ${CMAKE_CURRENT_SOURCE_DIR}/data/*.ogg
  ${CMAKE_CURRENT_SOURCE_DIR}/data/*.it
  ${CMAKE_CURRENT_SOURCE_DIR}/data/*.png
  ${CMAKE_CURRENT_SOURCE_DIR}/data/*.dat
  ${CMAKE_CURRENT_SOURCE_DIR}/data/*.lua
  ${CMAKE_CURRENT_SOURCE_DIR}/data/*.ttf
  ${CMAKE_CURRENT_SOURCE_DIR}/data/*.ttc
  ${CMAKE_CURRENT_SOURCE_DIR}/data/*.fon
)

# add other data to zip archive
add_custom_command(
  OUTPUT data.solarus
  DEPENDS ${data_files_prefixed}
  WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/data
  COMMAND zip -q ${CMAKE_CURRENT_BINARY_DIR}/data.solarus ${data_files}
)

add_custom_target(${quest_name}_data
  ALL
  DEPENDS data.solarus
)

# create a script that executes the engine with this quest
add_custom_command(
  OUTPUT ${quest_name}
  COMMAND echo '\#!/bin/sh' > ${quest_name}
  COMMAND echo 'solarus-run ${SOLARUS_INSTALL_ABSOLUTE_DATADIR}/${quest_name} $*' >> ${quest_name}
)
add_custom_target(${quest_name}_command
  ALL
  DEPENDS ${quest_name}
)

# install the data archive
install(FILES ${CMAKE_CURRENT_BINARY_DIR}/data.solarus
  DESTINATION ${SOLARUS_INSTALL_DATADIR}/${quest_name}
)

# install the script
install(PROGRAMS ${CMAKE_CURRENT_BINARY_DIR}/${quest_name}
  DESTINATION ${SOLARUS_INSTALL_BINDIR}
)

