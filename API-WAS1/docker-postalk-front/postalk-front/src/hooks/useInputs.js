import { useReducer } from 'react';

function reducer(state, action) {
  if (action.type === 'initial') {
    return action.state
  }
  
  return {
    ...state,
    [action.name]: action.value
  }
}

export default function useInputs(initialForm) {
  const [state, dispatch] = useReducer(reducer, initialForm)

  const onChange = e => {
    dispatch(e.target);
  }

  return [state, onChange, dispatch];
}