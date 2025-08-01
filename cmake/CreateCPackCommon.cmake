# Variables common to all CPack Generators
set(CPACK_PACKAGE_NAME ${CMAKE_PROJECT_NAME})
set(CPACK_PACKAGE_VENDOR ${QGC_ORG_NAME})
set(CPACK_PACKAGE_DIRECTORY ${CMAKE_BINARY_DIR})
set(CPACK_PACKAGE_VERSION_MAJOR ${PROJECT_VERSION_MAJOR})
set(CPACK_PACKAGE_VERSION_MINOR ${PROJECT_VERSION_MINOR})
set(CPACK_PACKAGE_VERSION_PATCH ${PROJECT_VERSION_PATCH})
set(CPACK_PACKAGE_DESCRIPTION ${PROJECT_DESCRIPTION})
# set(CPACK_PACKAGE_DESCRIPTION_FILE "")
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY ${PROJECT_DESCRIPTION})
set(CPACK_PACKAGE_HOMEPAGE_URL ${PROJECT_HOMEPAGE_URL})
set(CPACK_PACKAGE_FILE_NAME "${CPACK_PACKAGE_NAME}-${CPACK_PACKAGE_VERSION}-${CPACK_SYSTEM_NAME}")
set(CPACK_PACKAGE_INSTALL_DIRECTORY ${CMAKE_PROJECT_NAME})
set(CPACK_PACKAGE_ICON "${CMAKE_SOURCE_DIR}/resources/icons/CT-UAV.png")
# set(CPACK_PACKAGE_CHECKSUM "")
# set(CPACK_PROJECT_CONFIG_FILE "")
set(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_SOURCE_DIR}/.github/COPYING.md")
set(CPACK_RESOURCE_FILE_README "${CMAKE_SOURCE_DIR}/README.md")
# set(CPACK_RESOURCE_FILE_WELCOME "${CMAKE_CURRENT_SOURCE_DIR}/desc/welcome.txt")
# set(CPACK_MONOLITHIC_INSTALL
# set(CPACK_GENERATOR
# set(CPACK_OUTPUT_CONFIG_FILE
set(CPACK_PACKAGE_EXECUTABLES ${CMAKE_PROJECT_NAME})
# set(CPACK_STRIP_FILES
set(CPACK_VERBATIM_VARIABLES ON)
set(CPACK_THREADS -4)

# Variables for Source Package Generators
# set(CPACK_SOURCE_PACKAGE_FILE_NAME
# set(CPACK_SOURCE_STRIP_FILES
# set(CPACK_SOURCE_GENERATOR
# set(CPACK_SOURCE_OUTPUT_CONFIG_FILE
# set(CPACK_SOURCE_IGNORE_FILES

# Variables for Advanced Use
# set(CPACK_CMAKE_GENERATOR
# set(CPACK_INSTALL_CMAKE_PROJECTS
# set(CPACK_SYSTEM_NAME
# set(CPACK_PACKAGE_VERSION
# set(CPACK_TOPLEVEL_TAG
# set(CPACK_INSTALL_COMMANDS
# set(CPACK_INSTALL_SCRIPTS
# set(CPACK_PRE_BUILD_SCRIPTS
# set(CPACK_POST_BUILD_SCRIPTS
# set(CPACK_PACKAGE_FILES
# set(CPACK_INSTALLED_DIRECTORIES
# set(CPACK_PACKAGE_INSTALL_REGISTRY_KEY
# set(CPACK_CREATE_DESKTOP_LINKS
# set(CPACK_BINARY_<GENNAME>
# set(CPACK_READELF_EXECUTABLE
# set(CPACK_OBJCOPY_EXECUTABLE
# set(CPACK_OBJDUMP_EXECUTABLE
