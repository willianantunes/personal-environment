function create_development_workspace() {
  echo "<<<<<< Creating development workspace"

  mkdir -p $DEV_WORKSPACE_TOOLS \
  $DEV_WORKSPACE_GIT_PERSONAL \
  $DEV_WORKSPACE_GIT_WORK \
  $DEV_WORKSPACE_GIT_ENTREPRENEURSHIP \
  $DEV_WORKSPACE_TMP \
  $DEV_WORKSPACE_KEYS
}
