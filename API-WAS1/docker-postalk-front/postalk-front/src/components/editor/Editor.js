import React, { forwardRef, useRef, useEffect } from 'react'
import Quill from 'quill'
import 'quill/dist/quill.snow.css'

import './editor.scss'


/**
 * 사용법
 *
 * useRef 함수를 이용해서 ref생성 후 아래와 같이 전달
 *    - <Editor ref={ref} /> 
 * 
 * 그리고 작성 완료 후 내용을 가져올려면 아래와 같이 가져올 수 있음
 *    - ref.current.innerHTML
 */
const Editor = forwardRef(({ content }, ref) => {
  const editorRef = useRef()

  useEffect(() => {
    const quill = new Quill(editorRef.current, {
      theme: 'snow',
      placeholder: '본문을 작성해주세요',
      modules: {
        toolbar: [
          [{ 'header': '1'}, {'header': '2'}],
          [{size: []}],
          ['bold', 'italic', 'underline', 'strike', 'blockquote'],
          [{'list': 'ordered'}, {'list': 'bullet'}, {'indent': '-1'}, {'indent': '+1'}],
        ]
      }
    })

    ref.current = quill.root
  }, [])

  return (
    <div className="editor">
      <div ref={editorRef} dangerouslySetInnerHTML={{ __html: content }}></div>
    </div>
  )
})

export default Editor