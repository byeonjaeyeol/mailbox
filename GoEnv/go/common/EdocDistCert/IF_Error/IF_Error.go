package IF_Error

type IF_Error struct {
	ErrCode string
	ErrMsg  string
	Err     error
}

func (e *IF_Error) Error() string { return e.Err.Error() }
